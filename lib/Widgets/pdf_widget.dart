import 'package:flutter/material.dart';

class FilePreviewWidget extends StatelessWidget {
  final String fileName;
 

  // ignore: use_super_parameters
  const FilePreviewWidget({
    Key? key,
    required this.fileName,
  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // const Icon(
          //   Icons.insert_drive_file,
          //   color: Colors.grey,
          //   size: 32.0,
          // ),
          const Image(image: AssetImage('images/Filetype.png'),height: 30,),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
               
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 24.0,
          ),
        ],
      ),
    );
  }
}