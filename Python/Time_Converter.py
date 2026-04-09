def conversion(n):
    hours = n // 60
    mins = n % 60
    if hours > 1:
        print(hours, "hrs", mins, "minutes")
    else:
        print(hours, "hr", mins, "minutes")
   
   
minutes = int(input())
conversion(minutes)
