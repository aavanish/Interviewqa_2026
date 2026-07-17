# Complete Architecture Walkthrough — CI/CD + Networking Mechanism

**Purpose:** Answer "walk me through your architecture" with *mechanism* (why each step causes the next) instead of a list of tool names.

The trick interviewers are testing for: can you explain **what happens, why it happens, and what would break if that step didn't exist.** Every section below has all three.

---

## Part 1 — The full flow, end to end

### Stage 0: Foundation — what exists before any code is pushed (say this first)

Before any pipeline runs, the infrastructure already exists:

- A **VPC** with both **public and private subnets** across multiple Availability Zones (for high availability)
- **Public subnets** contain: the Load Balancer, and the NAT Gateway
- **Private subnets** contain: the EKS worker nodes (and therefore the pods)
- An **Internet Gateway (IGW)** attached to the VPC, referenced by the public subnet's route table
- The private subnet's route table sends `0.0.0.0/0` traffic to the **NAT Gateway** (not the IGW directly)
- **Security groups** control what can talk to what (e.g., only the Load Balancer's security group is allowed to hit the node's security group on the app port)
- IAM roles are configured so EKS nodes can pull from ECR (via the node IAM role or IRSA — IAM Roles for Service Accounts)

**Why this matters to say first:** it shows the interviewer you think about the system as a whole, not just "the pipeline." This context makes everything after it make sense.

---

### Stage 1: Code push → trigger

Developer pushes code to GitHub → a **webhook** fires → Jenkins CI job starts automatically.

*Mechanism to explain:* "GitHub doesn't push to Jenkins — Jenkins is configured to listen for GitHub's webhook event, so the moment a push happens, GitHub notifies Jenkins, which then pulls the code."

### Stage 2: Dependency check — OWASP

Jenkins pulls the code, then runs **OWASP Dependency Check** against the project's dependencies (e.g., `pom.xml`, `package.json`).

*Mechanism:* it cross-references your dependency versions against known CVE databases. If a library has a published vulnerability, the build can be configured to fail here — **before** any code quality or build work is wasted on code that's already unsafe at the dependency level.

### Stage 3: Code quality gate — SonarQube

SonarQube performs static analysis: bugs, code smells, duplication, security hotspots, test coverage.

*Mechanism:* it compares results against a **quality gate** (a threshold you define — e.g., 0 critical bugs, >80% coverage). If the code doesn't meet the gate, **the pipeline stops here** — this is a deliberate checkpoint, not just a report.

*Why this order matters:* dependency check happens before this because there's no point analyzing code quality if a base dependency is already critically vulnerable — fail fast on the cheaper check first.

### Stage 4: Filesystem scan — Trivy

Trivy scans the filesystem/codebase for vulnerabilities, misconfigurations, and secrets **before the Docker image is even built**.

*Mechanism:* catching an issue here is cheaper than catching it after the image is built and pushed — you're scanning source, not a built artifact yet.

### Stage 5: Build and push — Docker + ECR

Jenkins builds the Docker image from the Dockerfile, tags it (commit SHA or build number — never `latest`, and this is worth saying explicitly), then pushes it to **ECR**.

*Mechanism:* "Jenkins authenticates to ECR using AWS credentials (`aws ecr get-login-password`), which gives it a temporary token to push the image into our private ECR repository. ECR then also runs its own image scan on push, so we get a second layer of scanning — source-level via Trivy, and image-level via ECR — catching anything a new CVE disclosure might introduce after the build."

### Stage 6: CI triggers CD

Once the image is successfully pushed, the CI job triggers the **CD job** — a deliberately separate Jenkins pipeline.

*Why explain this as a design choice:* "We separate CI and CD so that build/security concerns and deployment concerns don't share a pipeline — if deployment logic changes, it doesn't risk breaking the build pipeline, and vice versa."

### Stage 7: Update manifest (GitOps)

The CD job updates the image tag in the Kubernetes manifest (or Helm `values.yaml`) and pushes that change to a **GitOps repository** — a separate repo from the application code.

*Mechanism:* "This repo isn't where our app code lives — it's the **source of truth for what should be running in the cluster.** We never manually run `kubectl apply`; the desired state lives in Git."

### Stage 8: Argo CD syncs the cluster

Argo CD **continuously watches** the GitOps repo. When it detects the manifest changed, it reconciles the live cluster state to match — pulling the new image tag and updating the deployment.

*Mechanism to explain clearly (this is a common follow-up):* "Argo CD polls or receives a webhook from the GitOps repo, diffs the desired state (what's in Git) against the actual state (what's running in the cluster), and if they differ, it applies the change. This is the core GitOps principle — Git is the source of truth, not a person running commands."

### Stage 9: Where it actually deploys — the networking mechanism

This is the part most people skip, and it's exactly what you flagged. Here's how to connect it:

1. Argo CD applies the deployment → new pods are scheduled on **EKS worker nodes sitting in private subnets**
2. To pull the image, the node reaches out to ECR — this outbound call goes: private subnet → route table → **NAT Gateway** (in the public subnet) → Internet Gateway → ECR. Inbound, nothing can reach the node directly, because there's no route from the IGW into the private subnet.
3. Once the pod is running, external users need to reach it. That traffic flows: **internet → Internet Gateway → Load Balancer (public subnet) → Target Group → Pod (private subnet)**, controlled by security groups that only allow the Load Balancer to talk to the nodes on the required port.

*Say it as one sentence if asked directly:* "Our compute is private for security, our entry and exit points are public and tightly controlled — the NAT Gateway handles outbound-only traffic like pulling images, and the Load Balancer handles inbound-only traffic like user requests, and neither path allows the internet to reach a pod directly."

### Stage 10: Monitoring and alerting

**Prometheus** scrapes metrics from the cluster (pod health, CPU/memory, request latency) at a set interval. **Grafana** visualizes those metrics on dashboards. If a stage fails anywhere in the pipeline, or a deploy succeeds/fails, an **email notification** goes out so the team has visibility without watching Jenkins.

---

## Part 2 — A full spoken narrative (practice this out loud)

> "Our infrastructure sits in a VPC with public and private subnets across multiple AZs. The EKS worker nodes live in private subnets for security, and the only internet-facing components are the Load Balancer and NAT Gateway, both in public subnets.
>
> When a developer pushes code to GitHub, a webhook triggers our Jenkins CI job. It pulls the code, runs an OWASP dependency check, then a SonarQube quality gate — if either fails, the pipeline stops there so we're not wasting time building something already broken. Once that passes, Trivy scans the filesystem, then Jenkins builds the Docker image and pushes it to ECR, which also runs its own image-level scan as a second layer of defense.
>
> That success triggers our CD pipeline, which updates the image tag in our GitOps repo — a separate repo that's the single source of truth for what should be running in the cluster. Argo CD is continuously watching that repo, and when it sees the change, it syncs the cluster to match — that's the GitOps model, so nobody runs `kubectl apply` manually.
>
> When the new pods come up in the private subnet, they pull the image from ECR through the NAT Gateway — outbound only. Once running, user traffic comes in through the Load Balancer in the public subnet and is routed to the pods — inbound only, and nothing else can reach the nodes directly.
>
> Once deployed, Prometheus and Grafana monitor the cluster, and we get email alerts on pipeline failures or deploy status, so the whole loop — code to production to visibility — is automated end to end."

---

## Part 3 — Why interviewers reject "keyword answers" (and how to self-check)

A keyword answer sounds like: *"We use Jenkins, SonarQube, Trivy, Docker, ECR, Argo CD, Kubernetes, Prometheus, Grafana."*

A mechanism answer always adds **one of these three connectors** after every tool name:
1. **"...which does X"** (what it actually does)
2. **"...so that Y"** (why it's there / what it prevents)
3. **"...and if it fails, Z happens"** (what the failure path looks like)

Before your interview, go tool by tool and make sure you can say all three for each one. If you get stuck on any tool, that's exactly where to spend your next hour of prep — not by memorizing more tools, but by understanding the one you're stuck on more deeply.
