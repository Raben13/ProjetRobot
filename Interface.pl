# -*- coding: utf-8 -*-
'''
Created on 9 f�vr. 2014

@author: Adam
'''

from tkinter import *
import math
from simulateur import *
class Interface(Frame):
    
    """Notre fen�tre principale.
    Tous les widgets sont stock�s comme attributs de cette fen�tre."""
    
    
      
    
    
    def __init__(self, fenetre, **kwargs):
        
        
        def maj():
            print("dsd")
        
        
        
        Frame.__init__(self, fenetre, width=2000, height=1024, **kwargs)
        self.pack(fill=BOTH)
        self.nb_clic = 0
        
        #Création de la zone dédié à la manipulation de l'axe Z
        ZFrame = Frame(self, width=1000, height=1000,relief=GROOVE)
        ZFrame.pack(side=LEFT,padx=60,pady=10)
        
        #Zone Graphique du robot suivant l'axe des Z
        self.ZArea = Canvas(ZFrame,bg="white", width=200, height=200,borderwidth=2,relief=GROOVE)
        self.ZArea.pack(padx=10)
        #Dessin du cercle de rayon r et de coordonnée (x,y)
        r = 40
        self.ZArea.create_oval(100-r, 100-r, 100+r, 100+r, outline='blue', fill='white')
        self.x = 100.0
        self.y = 100 - r
        self.ZLine = self.ZArea.create_line(100,100,self.x,self.y,fill = 'black')
        
        Label(ZFrame,text="Axe des Z").pack(side = BOTTOM)
        self.ZExValeur = 0
        self.ZValeur = StringVar()
        self.ZValeur.set(0)
        # Création de l'echelle des degré de Z
        self.echelleZ = Scale(ZFrame,from_=-180,to=180,resolution=0.1,orient=HORIZONTAL, length=200,width=10,tickinterval=90,variable = self.ZValeur,command=self.updateZ)
        self.echelleZ.pack(side = BOTTOM, padx=10)
        
        
        
        #Création de la zone dédié à la manipulation des axes X etY
        XYFrame = Frame(self, width=1000, height=1000,relief=GROOVE)
        XYFrame.pack(side=LEFT,padx=10,pady=10)
        
        self.YExValeur = 0
        self.YValeur = StringVar()
        self.YValeur.set(0)
        #Dessin du robot suivant l'axe des X et Y
        echelleYFrame = Frame(XYFrame, width=200, height=175,relief=GROOVE)
        echelleYFrame.pack(side = LEFT,padx=10,fill = Y) 
        # Création d'un widget Scale
        self.echelleY = Scale(echelleYFrame,from_=-180,to=180,resolution=0.1,orient=VERTICAL, length=200,width=10,tickinterval=50,variable = self.YValeur, command = self.updateY)
        self.echelleY.pack(side = TOP)
        Label(echelleYFrame,text="Axe des Y").pack(side = TOP)
       
        #Dessin du robot suivant l'axe des X et Y
        self.XYArea = Canvas(XYFrame,bg="white", width=200, height=200,borderwidth=2,relief=GROOVE)
        self.XYArea.pack(padx=10)
        
        Label(XYFrame,text="Axe des X").pack(side = BOTTOM)
        self.XExValeur = 0
        self.XValeur = StringVar()
        self.XValeur.set(0)
        # Création d'un widget Scale
        echelleX = Scale(XYFrame,from_=-180,to=180,resolution=0.1,orient=HORIZONTAL, length=200,width=10,tickinterval=50,variable = self.XValeur,command = self.updateX)
        echelleX.pack(side = BOTTOM, padx=10, fill = X)
        
        
        
        
        self.axe0 = (10,190)
        self.axe1 = (50,120)
        self.axe2 = (100,90)
        self.axe3 = (150,90)
        
        
        
        self.print_XYRobot()
        DETECTION_CLIC_SUR_OBJET = False
        # La méthode bind() permet de lier un événement avec une fonction
        self.XYArea.bind('<Button-1>',self.Clic) # évévement clic gauche (press)
        self.XYArea.bind('<B1-Motion>',self.Drag) # événement bouton gauche enfoncé (hold down)

        
                  



        
        
        
        
        
        
        # Cr�ation de nos widgets
        self.message = Label(self, text="Vous n'avez pas cliqu� sur le bouton.")
        self.message.pack()
        
        self.bouton_quitter = Button(self, text="Simulateur",command = self.simulation )
        self.bouton_quitter.pack(side="left")
        
        self.bouton_cliquer = Button(self, text="Quitter",command=self.quit)
        self.bouton_cliquer.pack(side="right")
    
    
    
    def updateZ(self,ZValeur):
        """ Met à jour le rayon suivant l'axe des Z """
        
        delta = float(self.ZValeur.get()) - float(self.ZExValeur)
        X = (self.x-100) * math.cos(math.radians((float(delta)))) - (self.y-100) * math.sin(math.radians((float(delta)))) +100
        Y = (self.x-100) * math.sin(math.radians(float(delta))) + (self.y-100) * math.cos(math.radians(float(delta))) +100
        self.x=X
        self.y=Y
        # mise à jour de la position de l'objet (drag)
        self.ZExValeur = self.ZValeur.get()
        self.ZArea.coords(self.ZLine,100,100,self.x,self.y)
    
    def simulation(self):
        
        self.simulateur = Simulateur(self.XValeur,self.YValeur,self.ZValeur)
        
    
    def print_XYRobot(self):
        (a,b) = self.axe0
        (c,d) = self.axe1
        self.XYLine_0_to_1 =  self.XYArea.create_line(a,b,c,d,fill = 'black')
        (a,b) = self.axe1
        (c,d) = self.axe2
        self.XYLine_1_to_2 =  self.XYArea.create_line(a,b,c,d,fill = 'blue')
        (a,b) = self.axe2
        (c,d) = self.axe3
        self.XYLine_2_to_3 =  self.XYArea.create_line(a,b,c,d,fill = 'red')
        
    def maj_XYRobot(self):
        (a,b) = self.axe0
        (c,d) = self.axe1
        self.XYArea.coords(self.XYLine_0_to_1,a,b,c,d)
        (a,b) = self.axe1
        (c,d) = self.axe2
        self.XYArea.coords(self.XYLine_1_to_2,a,b,c,d)
        (a,b) = self.axe2
        (c,d) = self.axe3
        self.XYArea.coords(self.XYLine_2_to_3,a,b,c,d)
        
         
    def updateX(self,XValeur):
        """ Met à jour le rayon suivant l'axe des Z """
        (a,b) = self.axe3
        a = float(a)
        b = float(b)
        (c,d) = self.axe2
        c = float(c)
        d = float(d)
        delta = float(self.XValeur.get()) - float(self.XExValeur)
        X = (a-c) * math.cos(math.radians(float(delta))) - (b-d) * math.sin(math.radians((float(delta)))) + c
        Y = (a-c) * math.sin(math.radians(float(delta))) + (b-d) * math.cos(math.radians(float(delta))) + d
        self.axe3 = (X,Y)
        # mise à jour de la position de l'objet (drag)
        self.XExValeur = self.XValeur.get()
        
        self.maj_XYRobot()    
    
    
        
    def updateY(self,YValeur):
        """ Met à jour le rayon suivant l'axe des Z """
        (a,b) = self.axe2
        a = float(a)
        b = float(b)
        (c,d) = self.axe1
        c = float(c)
        d = float(d)
        delta = float(self.YValeur.get()) - float(self.YExValeur)
        X = (a-c) * math.cos(math.radians(float(delta))) - (b-d) * math.sin(math.radians((float(delta)))) + c
        Y = (a-c) * math.sin(math.radians(float(delta))) + (b-d) * math.cos(math.radians(float(delta))) + d
        
        vecteur = (X-a,Y-b)
        self.axe2 = (X,Y)
        (u,v) = vecteur
        (e,f) = self.axe3
        self.axe3 = (u+e,v+f)
        # mise à jour de la position de l'objet (drag)
        self.YExValeur = self.YValeur.get()
       
        self.maj_XYRobot()
        
        
        
    def Clic(self,event):
        """ Gestion de l'événement Clic gauche """
        global DETECTION_CLIC_SUR_OBJET
    
        # position du pointeur de la souris
        X = event.x
        Y = event.y
    
        (a,b) = self.axe3
        if a-20<=X<=a+20 and b-20<=Y<=b+20: DETECTION_CLIC_SUR_OBJET = True
        else: DETECTION_CLIC_SUR_OBJET = False

    def Drag(self,event):
        """ Gestion de l'événement bouton gauche enfoncé """
        X = event.x
        Y = event.y
       
    
        if DETECTION_CLIC_SUR_OBJET == True:
            print("Position du pointeur -> ",X,Y)
            # limite de l'objet dans la zone graphique
            if X<0: X=0
            if X>200: X=200
            if Y<0: Y=0
            if Y>200: Y=200
            # mise à jour de la position de l'objet (drag)
            self.Move_Hand(X,Y)       
            
    def translation_match(self,centre,point,vecteur):        
        (a,b) = point
        a = float(a)
        b = float(b)
        (c,d) = centre
        c = float(c)
        d = float(d)
        (v1,v2) = vecteur
        
        for i in range(1,360) :
            X = (a-c) * math.cos(math.radians(float(i))) - (b-d) * math.sin(math.radians((float(i)))) + c
            Y = (a-c) * math.sin(math.radians(float(i))) + (b-d) * math.cos(math.radians(float(i))) + d
            (u1,u2) = (X-a,Y-b)
            print("True")
            if int(u1) == int(v1) and int(u2) == int(v2):
                print("True") 
                return True
            
        return False    
            
    
    
    
    
    
    
            
    def Move_Hand(self,X,Y):        
        (a1,b1) = self.axe3
        (a2,b2) = self.axe2
        (a3,b3) = self.axe1
        (a4,b4) = self.axe0
        (u,v) = (X-a1,Y-b1)
        
        if self.translation_match(self.axe2,self.axe3,(u,v)):
            self.axe3 = (a1+u,b1+v)
            
        elif self.translation_match(self.axe1,self.axe2,(u,v)):
                self.axe3 = (a1+u,b1+v)
                self.axe2 = (a2+u,b2+v)
                
        elif self.translation_match(self.axe0,self.axe1,(u,v)):
                self.axe3 = (a1+u,b1+v)
                self.axe2 = (a2+u,b2+v)
                self.axe1 = (a3+u,b3+v)
        
        self.maj_XYRobot()
        
        
        
        
        
        
            
        
