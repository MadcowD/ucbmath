
for x in range(12):
	print("We now try $({}) \\subset \\mathbb{{Z}}_{{12}}$.".format(x))
	print("\\begin{equation*}")
	print("\\begin{aligned}")
	ideal = [x*j % 12for j in range(12)]
	print("I_{} &= \\{{{}\\}} \\\\".format(x, ideal))
	for y in range(12):
		idealy = [y + i % 12 for i in ideal]
		print("{}+ I_{} &= \\{{{}\\}}\\\\".format(y, x, idealy, x))
		idealy = [y *i % 12 for i in ideal]
		print("{} I_{} &= \\{{{}\\}} \\subset I_{} \\\\".format(y, x, idealy, x))
	print("\\end{aligned}")
	print("\\end{equation*}")
	print("Therefore $({})$ is an ideal.".format(x))
	print("To compute the quotient ring we".format(x))
