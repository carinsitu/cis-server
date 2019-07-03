# language:fr

Fonctionnalité: Usage de bonus
  En tant que joueur
  Afin d'avoir un aspect ludique
  Je souhaite qu'un système de bonus soit intégré.

  En tant que développeur
  Afin de gérer les bonus
  Je souhaite gérer des modificateurs pour les valeurs envoyées à la voiture

  Contexte:
    Etant donné un serveur lancé
    Et une voiture appairée
    Et un controlleur appairé

  Scénario: Accélérer sans modificateur
    Étant donné que le joueur n'a pas de bonus
    Quand le joueur accélère de 100%
    Alors une accélération de 25% doit être envoyée à la voiture

  Scénario: Accélérer avec un boost
    Étant donné que le joueur a 1 bonus de boost
    Quand le joueur accélère de 100%
    Alors une accélération de 50% doit être envoyée à la voiture

  Scénario: Accélérer avec un boost
    Étant donné que le joueur a 2 bonus de boost
    Quand le joueur accélère de 100%
    Alors une accélération de 100% doit être envoyée à la voiture

  Scénario: Multiples bonus et limites
    Étant donné que le joueur a 3 bonus de boost
    Quand le joueur accélère de 100%
    Alors une accélération de 100% doit être envoyée à la voiture

