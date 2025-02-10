import 'package:chat_application/controller/home_controller.dart';
import 'package:chat_application/modal/userModal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    UserModal user = homeController.user!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: Colors.black,
        title: Text(
          'Profile Section',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () async {
              Get.bottomSheet(
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration:  BoxDecoration(
                      color: Colors.grey,
                      border: Border.symmetric(horizontal: BorderSide(color: Colors.grey.shade300,width: 0.4)),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap: () async {
                              await homeController.sendImageToServer(true);
                              Get.back();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: height*0.030,
                              child: Icon(Icons.camera_alt,color: Colors.blueGrey.shade300,size: height*0.025),

                            ),
                          ),
                          SizedBox(height: 10,),
                          Text('Camera',style: TextStyle(color: Colors.white),)
                        ],
                      ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10,),
                            GestureDetector(
                              onTap: () async {
                                await homeController.sendImageToServer(false);
                                Get.back();
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.black54,
                                radius: height*0.030,
                                child: Icon(Icons.photo_outlined,color: Colors.green.shade300,size: height*0.025,),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('Gallery',style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
              // await homeController.sendImageToServer();
            },
            child: GetBuilder<HomeController>(
              builder: (controller) => CircleAvatar(
                radius: height * 0.060,
                backgroundImage: (controller.user?.profileImage != null &&
                        controller.user!.profileImage!.isNotEmpty)
                    ? NetworkImage(controller.user!.profileImage!)
                    : null,
                child: (controller.user?.profileImage == null ||
                        controller.user!.profileImage!.isEmpty)
                    ? Icon(Icons.person, size: 30) // Default icon if no image
                    : null, // No child if image exists
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showUpdateNameDialog(user.name);
            },
            child: Container(
              height: height * 0.070,
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[900], // Same as TextField fillColor
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.person, color: Colors.purple),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GetBuilder<HomeController>(
                      builder: (controller) => Text(
                        controller.user?.name ?? "No Name",
                        // Show name from controller
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const Icon(Icons.edit, color: Colors.white70), // Edit icon
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),
          Container(
            height: height * 0.070,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[900], // Same as TextField fillColor
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                const Icon(Icons.mail, color: Colors.purple),
                const SizedBox(width: 10),
                Text(
                  '${user.email}', // Show name from controller
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            height: height * 0.070,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[900], // Same as TextField fillColor
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                const Icon(Icons.phone, color: Colors.purple),
                const SizedBox(width: 10),
                Text(
                  '${user.phone}', // Show name from controller
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),

          // Function to Show Update Name
        ],
      ),
    );
  }
}

void _showUpdateNameDialog(String? name) {
  TextEditingController nameController = TextEditingController(text: name);
  Get.defaultDialog(

    buttonColor: Colors.purple,
    titleStyle: TextStyle(color: Colors.white),
    title: "Update Name",
    middleTextStyle: TextStyle(color: Colors.white),
    content: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new name",
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    ),
    textConfirm: "Update",
    cancelTextColor: Colors.white,
    textCancel: "Cancel",
    confirmTextColor: Colors.white,
    backgroundColor: Colors.black,
    onConfirm: () async {
      if (nameController.text.isNotEmpty) {
         await Get.find<HomeController>(). updateUserName(nameController.text);
      }
      Get.back(); // Close the dialog
    },
  );
}
