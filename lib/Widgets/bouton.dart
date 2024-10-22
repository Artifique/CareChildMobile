import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text; // Texte à afficher sur le bouton
  final Color backgroundColor; // Couleur de fond du bouton
  final Color textColor; // Couleur du texte
  final IconData icon; // Icône à afficher
  final VoidCallback? onPressed; // Action lorsque le bouton est pressé

  const CustomButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
    this.icon = Icons.arrow_forward, // Icône par défaut (modifiable)
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
      style: ElevatedButton.styleFrom(
       
        backgroundColor:backgroundColor, // Utiliser la couleur de fond passée
        disabledBackgroundColor:backgroundColor, // Utiliser la couleur de fond passée
        foregroundColor: textColor, // Utiliser la couleur de texte passée
        minimumSize: const Size(double.infinity, 60), // Taille minimum
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Bords arrondis
        ),
      ),
      onPressed: onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Text(
              text, // Texte passé en paramètre
              style: TextStyle(
                color: textColor, // Appliquer la couleur du texte
                fontSize: 18,
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -5,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Icon(
                  icon, // Icône dynamique passée en paramètre
                  color: backgroundColor, // Couleur de l'icône
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ignore: non_constant_identifier_names
ElevatedButton MonButton(
  Color colo,
  Color textColor,
  String text,
  IconData icon,
  VoidCallback onPressed, // Utilisez VoidCallback pour les fonctions sans paramètres
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: colo, // Utiliser la couleur de fond passée
      disabledBackgroundColor: colo, // Utiliser la couleur de fond passée
      foregroundColor: textColor, // Utiliser la couleur de texte passée
      minimumSize: const Size(double.infinity, 50), // Taille minimum
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Bords arrondis
      ),
    ),
    onPressed: onPressed, // Passer la référence de la fonction
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Center(
          child: Text(
            text, // Texte passé en paramètre
            style: TextStyle(
              color: textColor, // Appliquer la couleur du texte
              fontSize: 18,
            ),
          ),
        ),
        Positioned(
          right: -10,
          bottom: 13,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Icon(
                icon, // Icône dynamique passée en paramètre
                color: colo, // Couleur de l'icône
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


// ignore: non_constant_identifier_names
ElevatedButton Filtres(Color couleur, Icon icon,double iconsize,double long,double larg,Function onPressed) {
      return ElevatedButton(
        onPressed: onPressed(), 
        child: Container(
          width: larg,
          height: long,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: couleur,
          ),
          child:Icon(
            Icons.filter,
            size: iconsize,
            color: const Color( 0xffffffff),
          )
        )
        );
    }
    
    onPressed() {
    }


///Cercle pour le profil
    // ignore: non_constant_identifier_names
    Container Profil(Color couleur, double long, double larg) {
      return Container(
            padding: const EdgeInsets.all(10),
            width: larg,
            height: long,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: couleur,
                width: 2,
              ),
              image: const DecorationImage(
                image: AssetImage('images/sy.png'),
                fit: BoxFit.cover,
              ),
            ),
          );
    }

  // Calendrier

  // ignore: non_constant_identifier_names
  Container Calendrier(String text,Color bg,Color color,double long, double larg,Color textcolor) {
    return Container(
      width: larg,
      height: long,
       decoration: BoxDecoration(
        color:bg,
       ),
       child: Column(
            children: [
              const Text(
                'Octobre 2024',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 45,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color,
                        width: 2,
                      )
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Lun',
                          style: TextStyle(
                            fontSize: 16,
                            color: textcolor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          '15',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                            ), 
                            )

                      ],
                    ),
                  )
                ],
              )
            ],
       ),
    );

  }

  //Rendez vous
  // Container Rendezvous(String titre,Color bg,HourFormat format, double long, double larg,Color textcolor) {
  //   return Container(
  //     width: larg,
  //     height: long,
  //      decoration: BoxDecoration(
  //       color: bg,
  //      ),
  //      child: Column(
  //        children: [
  //         const SizedBox(height:10),
  //         Text(
  //           titre,
  //           style: TextStyle(
  //             color:textcolor
  //           )
  //         )
  //        ],
  //      ),
  //   );


  // }



  // ignore: non_constant_identifier_names
  Container Rendezvous(
    String motif, 
    Color bg, 
    String date, 
    String heure, 
    String docteur, 
    String role, 
    String imagePath, 
    double long, 
    double larg, 
    Color textcolor) {
  return Container(
    width: larg,
    height: long,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(255, 88, 87, 87),
          blurRadius: 5,
          spreadRadius: 2,
          offset: Offset(0.0, 5.0),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de l'événement
          Text(
            motif,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textcolor,
            ),
          ),
          const SizedBox(height: 10),
          
          // Heure de l'événement
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    date,
                    style: TextStyle(
                      color: textcolor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    heure,
                    style: TextStyle(
                      color: textcolor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          // Informations du docteur
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: imagePath.isNotEmpty 
                    ? NetworkImage(imagePath) 
                    : const AssetImage('images/default_profil.png') as ImageProvider,
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        docteur,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textcolor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        role,
                        style: TextStyle(
                          fontSize: 12,
                          color: textcolor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 60),
                  GestureDetector(
                    onTap: () {
                      // Action à effectuer lors du clic sur 'Annuler'
                      if (kDebugMode) {
                        print('Rendez-vous annulé');
                      }
                      // Ajoutez ici la logique pour annuler le rendez-vous
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xff0B8FAC),
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  //Specialistes
  // ignore: dead_code, non_constant_identifier_names
Container sp_widget(String nom,String role, Color bg, String imagePath, double long, double larg, Color textcolor) {
    return Container(
      width: larg,
      height: long,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15), // Ajout de coins arrondis
         boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(255, 88, 87, 87),
          blurRadius: 5,
          spreadRadius: 2,
          offset: Offset(0.0, 5.0),
        ),
      ],
      
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
           CircleAvatar(
          radius: 40, // Taille de l'image du spécialiste
          backgroundImage: imagePath.isNotEmpty 
              ? NetworkImage(imagePath) 
              : const AssetImage('images/default_profil.png') as ImageProvider, // Image par défaut
        ),
          const SizedBox(width: 1),
          Padding(
            
            padding: const EdgeInsets.all(17.0),
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      nom,
                      style: TextStyle(
                        fontSize: 16, // Taille plus grande pour le titre
                        fontWeight: FontWeight.bold,
                        color: textcolor,
                      ),
                      
                    ),
                    const SizedBox(height: 5),
                   // ignore: sized_box_for_whitespace
                   Container(
                    width: 100, // Largeur du conteneur
                    child: Text(
                      role,
                      style: TextStyle(
                        fontSize: 12, // Taille plus grande pour le titre
                        fontWeight: FontWeight.bold,
                        color: textcolor,
                      ),
                      maxLines: 3, // Limite le nombre de lignes (facultatif)
                      overflow: TextOverflow.ellipsis, // Ajoute des points de suspension si le texte est trop long (facultatif)
                    ),
                  )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                     OutlinedButton(
                      onPressed: onPressed,
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(79, 28),
                        backgroundColor: const Color(0xff0B8FAC),
                       padding: const EdgeInsets.all(5),
                        side: const BorderSide(color: Colors.white, width:3 ), // Bordure blanche
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))), // Pas de borderRadius
                      ),
                      child: const Text(
                        'Creneau',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),

                     const SizedBox(width: 30),
                      OutlinedButton(
                      onPressed: onPressed,
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(50, 28),
                        backgroundColor: const Color(0xff0B8FAC),
                       padding: const EdgeInsets.all(5),
                        side: const BorderSide(color: Colors.white, width:3 ), // Bordure blanche
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))), // Pas de borderRadius
                      ),
                      child: const Icon(
                        Icons.message,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }



  // ignore: non_constant_identifier_names
  Container CustomRessource(double height,double width,double borderRadius, Image image,String text,Color backgroundColor,Color textColor, Color imageBackgroundColor,double imageSize,double textSize,IconData vocalIcon,VoidCallback onIconPressed,){
   return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(255, 88, 87, 87),
          blurRadius: 5,
          spreadRadius: 2,
          offset: Offset(0.0, 5.0),
        )
      ],
    ),
    child: Row(
      children: [
        // Image à gauche avec un fond personnalisé
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: imageSize,
            height: height,
            decoration: BoxDecoration(
              color: imageBackgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: image,
            ),
          ),
        ),
        // Espace entre l'image et le texte
        const SizedBox(width: 10),
        // Texte au milieu
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        // Icône vocale à droite
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(vocalIcon, color: Colors.black), // Icône vocale
            onPressed: onIconPressed, // Action lors du clic sur l'icône
          ),
        ),
      ],
    ),
  );
}


// ignore: non_constant_identifier_names
Container ac_widget( Color bg, String imagePath, double long, double larg, Color textcolor) {
    return Container(
      width: larg,
      height: long,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10), // Ajout de coins arrondis
       boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(255, 88, 87, 87),
          blurRadius: 5,
          spreadRadius: 2,
          offset: Offset(0.0, 5.0),
        ),
      ],
      ),
      child: Row(
         children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  radius: 40, // Taille de l'image du docteur
                  backgroundImage: AssetImage(imagePath), // Image du docteur
                ),
            ),
            const SizedBox(width: 20),
         Container(
             padding: const EdgeInsets.all(4),
             decoration: BoxDecoration(
               color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: const Color(0xff0B8FAC),width: 2),

             ),
             child: Text(
              'Prendre',
              style: TextStyle(color: textcolor),
              ),
         ),
         const SizedBox(width: 20),
         Container(
            padding: const EdgeInsets.all(4),
             decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: const Color(0xff0B8FAC),width: 2),

             ),
             child: Text(
              'Attente',
              style: TextStyle(color: textcolor),
              ),
         ),

      ],
      ),
    );
  }
// ignore: non_constant_identifier_names
Container accroche_widget( Color bg, String imagePath, String contenu,double long, double larg, Color textcolor) {
    return Container(
      width: larg,
      height: long,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10), // Ajout de coins arrondis
       boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(255, 88, 87, 87),
          blurRadius: 5,
          spreadRadius: 2,
          offset: Offset(0.0, 5.0),
        ),
      ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
           children: [
             Text(
                contenu,
                style: TextStyle(color: textcolor),
                ),
              
              const SizedBox(width: 40),    
                   Container(
             width: 70, // Largeur du rectangle
             height: 80, // Hauteur du rectangle
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(8), // Bords arrondis
               image: DecorationImage(
                 image: AssetImage(imagePath), // Image du docteur
                 fit: BoxFit.cover, // Ajuste l'image pour couvrir le conteneur
               ),
             ),
           ),  
        
        ],
        ),
      ),
    );
  }