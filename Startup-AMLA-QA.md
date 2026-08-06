# Interview Questions
## Project related questions
1. Explain you project flow?
2. How to build a multistage pipeline?
3. Why are you using SonarQube in your pipeline? What it do?
4. After the code is merged into the main branch, how does deployment happen?
5. Which deployment strategies do you use?
6. How do Trunk-Based Development (TBD) works?

## Docker questions
8. Docker image versioning, how do you use image tags in your organization?
9. Have you used Github Actions?
10. What is a runner?
11. How do you secure your CI CD pipelines?
12. If the deployment is successful but the wrong image has been uploaded, how will you trace that?
13. In production wrong image is deployed how will you debug without letting it down?
14. If the image size is of 5gb how will you reduce a image size?
    
## Kubernetes
16. Explain the Kubernetes architecture from Ingress to Application Pods.
17. Explain the Ingress Controller path
18. How pods communicate with each other?
19. You are using Kubernetes in AWS and somehow one node is not in ready state. How will you check and what you do?
20. Can you check the not ready state from kubelet?
21. If your cluster is healthy and app is not working, how will you debug it. Consider that the URL is giving error.
22. Explain Deployment, statefull set and Deamon sets? also asked to differentiate them with each other
23. If the deamonset pod is missing from the nod how will you debug

## Deployment Strategies
25. The deployment is successful and users are actively using the application. Which deployment strategy would you use?
26. The application has been deployed and I have to store the data of the pods app where should I store it
27. Difference between Persistent Volume PV and PVC Persistent Volume Claim
28. There are some pods in running state but the pv and pvc are not mounted how will you debug
29. Have you worked in HPA or autoscaling
30. How HPA collects the matrix?
31. CPU is getting high but HPA is not scaling how will you debug?
32. Can you explain the flow of Ingress from User to Application pod?
33. which ingress controller are you using ?
34. In your project, how do you manage SSL certificate?
35. How will you manage kubernets level ssl certification?
36. What are Probes in Kubernetes?
37. If the pods are getting started continuously because of prob, what will you inspect first?
38. Have you worked on Helm Charts?
