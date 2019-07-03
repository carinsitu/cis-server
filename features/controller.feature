# language:fr

  Fonctionnalité: Contrôle d'une voiture

    Contexte:
      Etant donné un serveur lancé
      Et une voiture appairée
      Et un controlleur appairé

    Scénario: Accélérer
      Quand j'appuie sur le bouton pour avancer
      Alors un message contenant la valeur de gaz doit être envoyé
