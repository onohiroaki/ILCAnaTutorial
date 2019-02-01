#####################################
#
#####################################
from StandardModel import EWPhys
import math
import random
from array import array

# --- LCIO dependencies ---
from pyLCIO import UTIL, EVENT, IMPL, IO, IOIMPL

_ewphys = EWPhys()

# ###################################
def generate_costheta_phi(ecm):
    ''' Generate one mu+mu- event by SM EW '''
    
    a1ova0 = _ewphys.SetEnergy(ecm)
    sigmax = 2 + a1ova0

    cosx = -10
    while ( cosx == -10 ) :
        x = random.random()
        fx = ( 1 + a1ova0*x + x*x ) / sigmax
        if fx < random.random():
            cosx = x

    phi = ( 2*random.random() - 1 ) * 2*math.pi

    return (cosx, phi)
        

# #####################################
if __name__ == "__main__":
    ''' Main part of this program '''

    #---- number of events per momentum bin -----
    nevt = 1000
    
    outfile = "E250GeV.Pee_mumu.slcio"
    
    #--------------------------------------------
    
    wrt = IOIMPL.LCFactory.getInstance().createLCWriter( )
    
    wrt.open( outfile , EVENT.LCIO.WRITE_NEW ) 
    
    print " opened outfile: " , outfile
    
    random.seed()
    
    #========== particle properties ===================
    
    ecm_nominal=500.0
    genstat  = 1
    pdg = [ 13, -13 ]
    charge = [ -1, 1]
    #pdg = 211
    mass =  0.105658 
    
    #=================================================
    
    # write a RunHeader
    run = IMPL.LCRunHeaderImpl() 
    run.setRunNumber( 29999 )  # Samae as processID 
    run.parameters().setValue("Generator","e+e- --> mu+mu- by SM. No ISR/BS")
    # run.parameters().setValue("PDG", pdg )
    # run.parameters().setValue("Charge", charge )
    # run.parameters().setValue("Mass", mass )
    wrt.writeRunHeader( run ) 
    #================================================
    
    
    for j in range( 0, nevt ):
    
        col = IMPL.LCCollectionVec( EVENT.LCIO.MCPARTICLE ) 
        evt = IMPL.LCEventImpl() 
    
        evt.setEventNumber( j ) 
    
        evt.addCollection( col , "MCParticle" )

        (cosx, phi) =generate_costheta_phi(ecm_nominal)  # Theta, phi of this event
        sinx = math.sqrt( (1 - cosx)*(1+cosx) )

        p = math.sqrt( ecm_nominal*ecm_nominal - mass*mass )
        px0 = p * math.cos( phi ) * sinx 
        py0 = p * math.sin( phi ) * sinx
        pz0 = p * cosx

        # Loop over 2 particle, first mu-(PDG=13), second=mu+(PDG=-13)
        #--------------- create MCParticle -------------------
        for ip in range( 0, 2):

            mcp = IMPL.MCParticleImpl() 

            mcp.setGeneratorStatus( genstat ) 
            mcp.setMass( mass )
            mcp.setPDG( pdg[ip] ) 

            psign = -1*charge[ip]
            momentum  = array('f',[ px0*psign, py0*psign, pz0*psign ] )  

            mcp.setMomentum( momentum )
            mcp.setCharge( charge[ip] ) 
        
            endpoint = array('d',[ 0, 0, 0 ] )  
            mcp.setEndpoint( endpoint ) 
            
        #-------------------------------------------------------
        
            col.addElement( mcp )
        
        wrt.writeEvent( evt ) 
    
    wrt.close() 
    
