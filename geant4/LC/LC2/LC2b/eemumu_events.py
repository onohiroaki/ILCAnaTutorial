import math
import cmath


class EWPhys():
    def __init__(self):
        self.sinThetaW2 = 0.23
        self.alpha = 1.0/128.0
        self.pi = math.acos(-1.0)
        
        self.e2 = 4.0*self.pi*self.alpha
        self.g = math.sqrt(self.e2/self.sinThetaW2)
        self.sinThetaW = math.sqrt(self.sinThetaW2)
        self.gz = self.g/self.sinThetaW

        self.coupling = {}
        self.coupling["e"] = {"T3": -0.5, "Q":-1}

        for lep in self.coupling.keys():
           v = self.coupling[lep]
           v["cV"] = v["T3"] - 2 * self.sinThetaW2 * v["Q"]
           v["cA"] = v["T3"]
           v["cL"] = v["cV"] + v["cA"]
           v["cR"] = v["cV"] - v["cA"]


        self.mZ = 91.1876
        self.wZ = 2.4952
        self.mW = 80.379
        self.wW = 2.085
        
    def SetEnergy(self, ecm):
        G = math.sqrt(2)* self.g**2 / ( 8.0* self.mW**2 )

        s = ecm*ecm
        numerator = math.sqrt(2.0) * G * self.mZ**2 
        denominator = complex(s - self.mZ**2, self.mZ * self.wZ)
        r = (s/self.e2) * numerator / denominator 
        rabs = abs(r)
        rsquare = rabs*rabs

        cv = self.coupling["e"]["cV"]
        ca = self.coupling["e"]["cA"]

        self.A0 = 1 + 2*r.real * cv**2 + rsquare*(cv*cv + ca*ca)**2
        self.A1 = 4 * r.real * ca**2 + 8*rsquare * cv**2 * ca**2
        self.A1ovA0 = self.A1/self.A0
         
        return self.A1ovA0

# ###################################
if __name__ == "__main__":

    ewp = EWPhys()
    print ewp.sinThetaW2

    for ene in range(10, 500, 10) + [ 91.18 ] :
       a1ova0 = ewp.SetEnergy(ene)
       afb = a1ova0 / ( 8.0/3.0)
       print str(ene) + " " + str(a1ova0) + " AFB=" + str(afb)
    
