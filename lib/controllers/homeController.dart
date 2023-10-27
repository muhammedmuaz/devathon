import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('etc');

  // sort certificate

  // For Sorting

  // void sortCertificates() {
  //   filteredCertificate
  //       .sort((a, b) => b.dateobtained!.compareTo(a.dateobtained!));
  //   update();
  // }

// Convert XFile
  Future<File> convertXFileToFile(File xFile) async {
    final String path = xFile.path;
    return File(path);
  }

  // Upload to Firebase

  // void uploadprreceiptforUser(Prreceipt receipt, List<File> image) async {
  //   try {
  //     List<String> downloadUrl = [];
  //     isuploadingcertificate = true;
  //     var userid = GetStorage().read("userid");
  //     for (var i = 0; i < image.length; i++) {
  //       var uuid = Uuid();
  //       String uniqueFileName = '${uuid.v4()}.jpg';
  //       update();
  //       FirebaseStorage storage = FirebaseStorage.instance;
  //       var snapshot = await storage
  //           .ref()
  //           .child('prreceipts/$uniqueFileName')
  //           .putFile(image[i])
  //           .whenComplete(() => null);
  //       await snapshot.ref
  //           .getDownloadURL()
  //           .then((value) => downloadUrl.add(value));
  //     }
  //     // Assuming you have initialized Firebase using Firebase.initializeApp()
  //     CollectionReference prreceiptCollection =
  //         FirebaseFirestore.instance.collection('prreceipt');

  //     await prreceiptCollection.add({
  //       'receiptid': receipt.receiptid,
  //       'receiptbusinessname': receipt.receiptbusinessname,
  //       'clientbusinessname': receipt.clientbusinessname,
  //       'personalincluded': receipt.personalIncluded,
  //       'city': receipt.city,
  //       'userid': userid,
  //       'value': receipt.value,
  //       'prreceiptimg': downloadUrl,
  //       'notificationid': datelistcontroller.notifyid2 ?? 0
  //     });
  //     loadPrReceiptForUser();
  //     loadNotifications();
  //     isuploadingcertificate = false;
  //     update();
  //     Get.offAll(const BottomsNavigation());
  //     BotToast.showText(text: 'Receipt uploaded successfully');
  //   } catch (e) {
  //     isuploadingcertificate = false;
  //     update();
  //     BotToast.showText(text: 'Receipt not uploaded successfully');
  //   }
  // }

  // Load Certificates

  // Future<void> loadCertificatesForUser() async {
  //   try {
  //     var userid = GetStorage().read("userid");
  //     final QuerySnapshot querySnapshot =
  //         await FirebaseFirestore.instance.collection('certificate').get();

  //     final List<Certificate> userCertificates =
  //         querySnapshot.docs.where((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       if (data['userId'] == userid) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     }).map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return Certificate(
  //           certificateId: data['certificateId'],
  //           certificatename: data['certificatename'],
  //           certificatenumber: data['certificatenumber'],
  //           certificateprovider: data['certificateprovider'],
  //           dateobtained: data['dateobtained'],
  //           expirydate: data['expirydate'],
  //           certificateimg: data['certificateimg'],
  //           notificationid: data['notificationid']);
  //     }).toList();
  //     certificates.assignAll(userCertificates);
  //     filteredCertificate.assignAll(userCertificates);
  //     if (filteredCertificate.length > 1) {
  //       sortCertificates();
  //     }
  //     update();
  //   } on FirebaseException catch (e) {
  //     BotToast.showText(text: 'Error loading certificates: $e');
  //   }
  // }

// delete

// Future<void> delete(
//       int id, int notificationid, String where, String collection) async {
//     try {
//       isloading = true;
//       update();
//       final CollectionReference certificatecollection =
//           FirebaseFirestore.instance.collection(collection);
//       QuerySnapshot querySnapshot =
//           await certificatecollection.where(where, isEqualTo: id).get();
//       for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
//         await documentSnapshot.reference.delete();
//       }

//       final CollectionReference notificationcollection =
//           FirebaseFirestore.instance.collection('notifications');

//       QuerySnapshot notificationquerySnapshot = await notificationcollection
//           .where('id', isEqualTo: notificationid)
//           .get();
//       for (QueryDocumentSnapshot notificationSnapshot
//           in notificationquerySnapshot.docs) {
//         await notificationSnapshot.reference.delete();
//       }
//       await loadNotifications();
//       isloading = false;
//       // update();
//     } on FirebaseException catch (e) {
//       BotToast.showText(text: 'Error Deleting document: $e');
//       isloading = false;
//       update();
//     } catch (e) {
//       BotToast.showText(text: 'Error');
//       isloading = false;
//     }
//   }

// Update Profile

// Future<void> updateuser(XFile? image, bool uploadimg, bool changepass) async {
//     try {
//       isupdatinguser = true;
//       update();
//       var downloadUrl;
//       if (uploadimg) {
//         // image upload
//         File img2 = await convertXFileToFile(image!);
//         var uuid = Uuid();
//         String uniqueFileName = '${uuid.v4()}.jpg';
//         FirebaseStorage storage = FirebaseStorage.instance;
//         var snapshot = await storage
//             .ref()
//             .child('users/$uniqueFileName')
//             .putFile(img2)
//             .whenComplete(() => null);
//         downloadUrl = await snapshot.ref.getDownloadURL();
//       }

//       // var userid = await GetStorage().read("userid");
//       // Retrieve the user document based on the userid
//       // QuerySnapshot userSnapshot =
//       //     await users.where('userid', isEqualTo: userid).get();
//       // Check if a user with the specified userid exists

//       // Update the username and password fields
//       if (uploadimg && changepass) {
//         await user!.updateDisplayName(cunController.text);
//         await user!.updatePhotoURL(downloadUrl);
//         await user!.updatePassword(cpnController.text);
//         await GetStorage().erase();
//         Get.offAll(() => const LoginScreen());
//         BotToast.showText(text: 'Login Again');
//       } else if (uploadimg) {
//         await user!.updateDisplayName(cunController.text);
//         await user!.updatePhotoURL(downloadUrl);
//       } else if (changepass) {
//         await user!.updateDisplayName(cunController.text);
//         await user!.updatePassword(cpnController.text);
//         await GetStorage().erase();
//         Get.offAll(() => const LoginScreen());
//         BotToast.showText(text: 'Login Again');
//       } else {
//         await user!.updateDisplayName(cunController.text);
//       }
//       await user!.reload();
//       user = FirebaseAuth.instance.currentUser;
//       isupdatinguser = false;
//       update();
//       // Show a success message or perform any necessary actions
//       BotToast.showText(text: 'Username and Password updated successfully');
//     } catch (e) {
//       print(e);
//       BotToast.showText(text: 'Error deleting user: $e');
//     }
//   }

//  Download Image from URL

  // Future<void> downloadAndSaveImage(String imageUrl) async {
  //   try {
  //     // Send an HTTP GET request to fetch the image data
  //     final http.Response response = await http.get(Uri.parse(imageUrl));

  //     // Check if the request was successful (status code 200)
  //     if (response.statusCode == 200) {
  //       // Get the app's temporary directory to save the image
  //       final Directory appDir = await getTemporaryDirectory();
  //       final File imageFile = File('${appDir.path}/image.png');

  //       // Write the image data to the file
  //       await imageFile.writeAsBytes(response.bodyBytes);

  //       // You can now use `imageFile` to display or process the image as needed.
  //       // For example, you can display it in an Image widget:
  //       // Image.file(imageFile);
  //     } else {
  //       throw BotToast.showText(text: 'Failed to load image');
  //     }
  //   } catch (e) {
  //     throw BotToast.showText(text: 'Error');
  //   }
  // }

// Share Image

  // Future<void> shareImage(String imageUrl) async {
  //   try {
  //     // Download and save the image
  //     await downloadAndSaveImage(imageUrl);

  //     // Get the app's temporary directory
  //     final Directory appDir = await getTemporaryDirectory();

  //     // Construct the list of file paths to share (in this case, just one image)
  //     final List<String> paths = [appDir.path + '/image.png'];

  //     // Share the image using the share package
  //     await Share.shareFiles(
  //       paths,
  //       text: 'Navigator!',
  //     );
  //   } catch (e) {
  //     throw BotToast.showText(text: 'Failed to load image');
  //   }
  // }

// send email

  // Future<void> sendEmail(List<String>? attachments) async {
  //   final Email email = Email(
  //     subject: '',
  //     recipients: [],
  //     cc: [],
  //     bcc: [],
  //     attachmentPaths: attachments,
  //     // body: 'This is the body of the email.',
  //     isHTML: false,
  //   );

  //   try {
  //     await FlutterEmailSender.send(email);
  //     // BotToast.showText(text: "Email sent successfully");
  //   } catch (error) {
  //     // BotToast.showText(text: "Error sending email");
  //   }
  // }
}
