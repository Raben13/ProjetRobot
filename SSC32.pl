__author__ = 'Ben younes Radhoane & Adam Tiamiou'

import serial
import math
import Servo

# SSC32 permet la communication entre la carte ss32 et l'utulisateur. 
class SSC32(object):

    def __init__(self, port, count=5,baudrate, autocommit=None):
        self.autocommit = autocommit # Permet de définir la vitesse o
        self.ser = serial.Serial(port, baudrate, timeout=1) # Socket de connexion
        self.ser.write('\r'*10) # On initialise la carte en envoyant 10 fois RetourChar.
        self._servos = [Servo(self, i) for i in xrange(count)] # On associe tous les servos associé à cette connexion.
        
 # On vide le buffer
    #Fermer la connexion
    def fermutre(self):
        self.ser.close()

    #def __del__(self):
    #    self.close()

    #Représentation de la forme format(self.ser.port,self.ser.baudrate) pour l'interface.
    def __repr__(self):
        return '<SSC32: {0} {1},8,N,1 >'.format(self.ser.port,self.ser.baudrate)
    
    # Fonction ecriture
    def write (self,text):
        self.ser.write(text)
    
    def Position (self,numServo):
        position = 'QP {0} <cr>'.format(numServo) # QP permet de demander à la carte la position du Servo numServo. 
        self.ser.write(position)
        Us = self.lire();# On lit la position envoyé en Us . 
        return To_Degrees (Us*10) # *10 voir manuel.
    
    #Fonction permettant de lire la reponse suite à une requete (trouver dans le Forum lynx)
    def read(self):
        self.ser.read()
    
    #Fonction permettant de lire la reponse suite à une requete (trouver dans le Forum lynx)
    
    def lire (self):
        ich = "";
        inp = "";

        while (ich != '\r'):
                ich = self.ser.read(1);

                if (ich !='\r'): #tant qu'il n'y pas de marque d'arrêt. On continu a lire
                        inp = inp + ich;
        return inp;
    
    #Cette fonction per
    
    def Ismoving (self):
        self.ser.flushInput() # On efface le buffer d'entrer.
        self.ser.write('Q\n \r') # Cette commande Q permet de demander à la carte si le robot est en mouvement
        r = self.lire()
        return r == '+' # Si true alors le robot est en mouvement . (voir manuel)
    
    # Permet de rajouter tous les Servos .
    def __getitem__(self, it):
        if type(it) == str or type(it) == unicode:
            for servo in self._servos:
                it = it.upper()
                if servo.name == it:
                    return servo
            raise KeyError(it) # En cas d'erreur 
        return self._servos[it]

    def __len__(self):
        return len(self._servos) # return le nbr de servos 

   #Permet d'envoyer les commandes 
    def _servo_on_changed(self):
        if self.autocommit is not None:
            self.commit(self.autocommit)
            
    #Fonction principale: Commit permet d'envoyer toutes les commandes à la carte 
    def commit(self, time=None):
        """
        De la forme ([#<n>P<pos>]T<time>) avec n le numéro du Servo 
        """
        cmd = ''.join([self._servos[i]._get_cmd_string() for i in xrange(len(self._servos))])
        if time is not None: #Si le temps est précisé alors: 
            cmd += 'T{0}'.format(time)
        cmd += '\n'
        self.ser.write(cmd)
    
    #
    def _servo(self):
        if self.autocommit is not None:
            self.commit(self.autocommit)
    
#Convertire Position uS en Degrees SSC-32
def To_Degrees (uS):
        result= 0;
   
        result = (uS - 1500) / 10;
   
        return result;

# Converti la SSC-32 position d'u position in uS to degrees
def To_uS (degrees):
   result = 0;
   
   result = (degrees * 10) + 1500;
   
   return result;


