// import 'package:accessability/Services/message_service.dart';
// import 'package:flutter/material.dart';

// class DemandesAdhesionPage extends StatefulWidget {
//   final String idGroupe;
//   const DemandesAdhesionPage({Key? key, required this.idGroupe}) : super(key: key);

//   @override
//   _DemandesAdhesionPageState createState() => _DemandesAdhesionPageState();
// }

// class _DemandesAdhesionPageState extends State<DemandesAdhesionPage> {
//   late Stream<List<Map<String, dynamic>>> _demandesStream;

//   @override
//   void initState() {
//     super.initState();
//     _demandesStream = MessageService().recevoirDemandesAdhesion(widget.idGroupe);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Demandes d\'adhésion')),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: _demandesStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('Aucune demande d\'adhésion.'));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               var demande = snapshot.data![index];
//               return ListTile(
//                 title: Text(demande['demandeurId']),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.check),
//                       onPressed: () async {
//                         await MessageService().accepterDemande(demande['id'], widget.idGroupe, demande['demandeurId']);
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () async {
//                         await MessageService().refuserDemande(demande['id']);
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }