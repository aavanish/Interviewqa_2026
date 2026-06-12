#CLASS AND OBJECT

class Car:
    def __init__(self, brand, model):
        self.brand = brand
        self.model = model

    def drive(self):
        print(f"{self.model} {self.brand} is driving!")


car1 = Car("VM", "Red")
car2 = Car("BMW", "Blue")

car1.drive()
car2.drive()

