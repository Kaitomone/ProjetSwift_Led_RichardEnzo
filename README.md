# Projet Led sur Swift

# Présentation/Introduction

FR Le projet Led est une application réalisés sur Swift avec la librairie CocoaMQTT, qui permet de se connecter à un broker mosquito, et par la suite s'abonner à des topics. Lorque la configuration est terminé vous pourrez envoyer un message à un panneau Led, vous pourrez aussi donner la couleur du texte avec des valeurs RGB. Vous pourrez aussi changer la langue du projet pour français ou anglais.

EN The Led project is an application developed in Swift using the CocoaMQTT library, which allows you to connect to a Mosquito broker and subsequently subscribe to topics. Once the configuration is complete, you can send a message to an LED panel and also specify the text color using RGB values. You can also change the project language to English or French.

# Langage de programmation/Programming language

FR Le langage utilisé est Swift, un langage conçus pour iOS.

EN The language used is Swift, a language designed for iOS.

# Installation/Install
FR Pour installer l'application vous devez cloner le dépôt git et lancer l'application dans Swift.

EN To install the application, you need to clone the Git repository and launch the application in Swift.

# Utilisation/Application

FR Pour vous connecter à l’application il vous suffit juste de la lancer, ensuite il faudra rentrer vos identifiants de connexion. Votre nom d’utilisateur et votre mot de passe. Celui par défaut pour vous est « Enzo » pour le nom d’utilisateur et « Richard » pour le mot de passe. 

Accueil 

Après vous être connectés, vous vous retrouverez sur la page principale. Vous pourrez voir un bandeau en haut de votre écran, celui-ci indique si vous êtes connectés au Broker Mosquito, celui qui permet de communiquer entre l’ESP32 et votre application mobile. Lorsque le bandeau affiche « Déconnecté » il vous faudra aller dans l’onglet « Paramètres », que l’on verra juste après. 

Lorsque vous serez connecté, vous pourrez alors écrire dans les différentes zones de texte. Vous avez vos 3 zones pour la couleur, qui fonctionne avec les couleurs RVB (Rouge, Vert, Bleu), il faudra alors entrer une valeur entre 0 et 255 dans chaque zone. 

Ensuite vous pourrez remplir la zone de texte pour le message que vous voulez écrire. Enfin vous pourrez cliquer sur le bouton « Envoyer » et la configuration du message sera envoyée au Broker. 

La taille du panneau utilisé est envoyée depuis l’ESP32 et est affichée à la place du « panneau » en gris. 

Paramètres 

Dans l'onglet "Paramètres", vous pouvez entrer les informations nécessaires pour vous connecter au Broker Mosquito et pour vous abonner au topic approprié. Tout d'abord, entrez l'adresse du Broker Mosquito dans la zone prévue à cet effet. Lorsque vous avez entré l'adresse, appuyez sur le bouton "Enregistrer" pour vous connecter au Broker. 

Une fois connecté, vous pouvez entrer le topic approprié dans la zone prévue à cet effet. Assurez-vous d'entrer le bon topic pour que vous puissiez recevoir les messages qui vous sont destinés. Lorsque vous avez entré le topic, appuyez sur le bouton "Enregistrer" pour vous abonner au topic. 

Une fois que vous êtes abonné au topic, le bandeau en haut de l'écran passera en mode "Abonné". Vous pouvez maintenant envoyer des messages à votre panneau LED en utilisant l'interface principale. Si jamais le bandeau passe en mode "Déconnecté", retournez à l'onglet "Paramètres" pour vérifier que les informations sont correctes et reconnectez-vous au Broker en appuyant sur le bouton "Enregistrer". 

L’adresse du Broker est 172.16.5.101. Il faut être connecté au réseau « EcoleDuWeb2.4GHz » ou « EcoleDuWeb5GHz ». 

Le topic pour envoyer un message est « Enzo/led/couleur » et le topic pour recevoir la taille du panneau est « Enzo/led/panneau ». 

EN To connect to the application, simply launch it and then enter your login credentials, including your username and password. The default username is "Enzo" and the default password is "Richard".

Home Screen

Once you have logged in, you will be taken to the main page. You will see a banner at the top of your screen indicating whether you are connected to the Mosquito broker, which allows communication between the ESP32 and your mobile application. If the banner shows "Disconnected," you will need to go to the "Settings" tab, which we will discuss shortly.

When you are connected, you can then enter text into the various text fields. You have three fields for color, which work with RGB colors (Red, Green, Blue). You will need to enter a value between 0 and 255 in each field.

Next, you can fill in the text field for the message you want to write. Finally, you can click the "Send" button, and the message configuration will be sent to the broker.

The size of the panel used is sent from the ESP32 and is displayed in place of the gray "panel" placeholder.

Settings

In the "Settings" tab, you can enter the necessary information to connect to the Mosquito broker and subscribe to the appropriate topic. First, enter the address of the Mosquito broker in the field provided. Once you have entered the address, press the "Save" button to connect to the broker.

Once connected, you can enter the appropriate topic in the field provided. Make sure you enter the correct topic so that you can receive messages intended for you. Once you have entered the topic, press the "Save" button to subscribe to the topic.

Once you have subscribed to the topic, the banner at the top of the screen will switch to "Subscribed" mode. You can now send messages to your LED panel using the main interface. If the banner switches to "Disconnected" mode, go back to the "Settings" tab to check that the information is correct and reconnect to the broker by pressing the "Save" button.

The broker address is 172.16.5.101. You must be connected to the "EcoleDuWeb2.4GHz" or "EcoleDuWeb5GHz" network.

The topic to send a message is "Enzo/led/couleur" and the topic to receive the panel size is "Enzo/led/panneau".

Copyright
Kaitomone/Enzo Richard
EPEE Cegep Rivière-du-Loup
