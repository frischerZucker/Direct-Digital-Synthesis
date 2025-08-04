import math
import os

SRC_DIR = os.path.abspath(os.path.dirname(__file__))
FILE = f"{SRC_DIR}/coefs"

PHASENAUFLÖSUNG = 4095
AMPL_AUFLÖSUNG = 1023

def get_coef(n: int) -> int:
    c = int(((math.sin((n*2*math.pi)/(PHASENAUFLÖSUNG+1))+1)*AMPL_AUFLÖSUNG)/2)
    return c

if __name__ == "__main__":
    with open(FILE, "w") as fd:
        fd.write("signal coef_table : coef_table_t := (")
        for i in range(0, PHASENAUFLÖSUNG):
            fd.write(f"{i}=>{get_coef(i)},")

        fd.write(f"{PHASENAUFLÖSUNG}=>{get_coef(PHASENAUFLÖSUNG)});\n")