"""
latex_table_from_F1_F_list(extensions,q,g,d,g1)

Requires:
- load("utils/cyclic_covers.sage")
- load("utils/weil_poly_utils.sage")

Input:
- q:          prime power
- d:          positive integer
- g, g1:      positive integers
- extensions: a list of extensions (F,F1) of Magma AlgoritmicFunctionFields where F1/F
              is a purely geometric extension of degree d over Fq, with g and g1 the
              genera of F and F1.
Output:
- The LaTeX code included in the article.
"""
def latex_table_from_F1_F_list(extensions,q,g,d,g1):
    # start the table
    latex_code = "\\begin{table}[ht] \n"
    latex_code += "    \\setlength{\\arrayrulewidth}{0.2mm}\n"
    latex_code += "    \\setlength{\\tabcolsep}{5pt} \n"
    latex_code += "    \\renewcommand{\\arraystretch}{1.2}\n"
    latex_code += "    \\centering \n"
    latex_code += "    \\begin{tabular}{|c|c|}\n"
    latex_code += "        \\hline\n        \\rowcolor{headercolor}\n"
    # title row
    latex_code += "        $J$ & $F$ \\\\\n        \\hline\n"
    # loop over the extensions in the list and add (J,F) as a row in the table
    for extension in extensions:
        F = extension[0]
        F1 = extension[1]
        BaseField = F.ConstantField().sage()
        R0.<x> = BaseField[]
        R1.<y> = R0[]
        # verify that the data is as expected
        assert q == len(BaseField)
        assert g == Integer(F.Genus())
        assert g1 == Integer(F1.Genus())
        assert d == F1.Degree(F)
        point_count = tuple(Integer(F.NumberOfPlacesOfDegreeOneECF(i)) for i in range(1, g+1))
        poly = weil_poly_from_point_count(point_count, q)
        label = label_from_weil_poly(poly)
        u = magma_poly_list(F.DefiningPolynomial())
        u = [R0(i.Numerator().sage())/R0(i.Denominator().sage()) for i in u]
        u = R1(u)
        latex_code += f"        \\avlink{{{label}}} & ${latex(u)}$ \\\\\n        \\hline\n"
    # End the table
    latex_code += "    \\end{tabular} \n"
    latex_code += f"\\caption{{Purely geometric covers of type $(q,g,d,g') = ({q},{g},{d},{g1})$.}} \n"
    latex_code += f"\\label{{tab:geometric_q{q}_g{g}_d{d}_g'{g1}}} \n"
    latex_code += "\\end{table}"
    return latex_code



"""
save_table_from_F1_F_list(extensions,q,g,d,g1)

Requires:
- load("utils/cyclic_covers.sage")
- load("utils/weil_poly_utils.sage")

Input:
- q:          prime power
- d:          positive integer
- g, g1:      positive integers
- extensions: a list of extensions (F,F1) of Magma AlgoritmicFunctionFields where F1/F
              is a purely geometric extension of degree d over Fq, with g and g1 the
              genera of F and F1.
Output:
- .txt file saved in the /tables directory.
"""
def save_table_from_F1_F_list(extensions,q,g,d,g1):
    # open a file in write mode
    file_name = f"tables/table_q{q}_g{g}_d{d}_gg{g1}.txt"
    with open(file_name, "w") as file:
        # write each entry on a new line
        for i, extension in enumerate(extensions):
            F = extension[0]
            F1 = extension[1]
            BaseField = F.ConstantField().sage()
            R0.<x> = BaseField[]
            R1.<y> = R0[]
            # verify that the data is as expected
            assert q == len(BaseField)
            assert g == Integer(F.Genus())
            assert g1 == Integer(F1.Genus())
            assert d == F1.Degree(F)
            point_count = tuple(Integer(F.NumberOfPlacesOfDegreeOneECF(i)) for i in range(1, g+1))
            poly = weil_poly_from_point_count(point_count, q)
            label = label_from_weil_poly(poly)
            u = magma_poly_list(F.DefiningPolynomial())
            u = u = [R0(i.Numerator().sage())/R0(i.Denominator().sage()) for i in u]
            u = R1(u)
            entry = f"{label}, {u}"
            if i < len(extensions)-1:
                file.write(entry + "\n")
            else:
                file.write(entry + "\n")
    print("Table " + file_name + " saved!")