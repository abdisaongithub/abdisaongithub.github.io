// import 'package:flutter/material.dart';
//
// void showChangePasswordBottomSheet(
//   BuildContext context,
// ) {
//   _baseFunction(
//     context: context,
//     builder: (_) {
//       return Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             // ChangePasswordBottomSheet(),
//           ],
//         ),
//       );
//     },
//   );
// }
//
// void showDeleteAccountBottomSheet(
//   BuildContext context,
// ) {
//   _baseFunction(
//     context: context,
//     builder: (_) {
//       return Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             // DeleteBottomSheet(),
//           ],
//         ),
//       );
//     },
//   );
// }
//
// void showChangeEmailBottomSheet(
//   BuildContext context,
//   bool isChangeEmail,
// ) {
//   _baseFunction(
//     context: context,
//     builder: (_) {
//       return Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             // ChangeEmailBottomSheet(isChangeEmail: isChangeEmail),
//           ],
//         ),
//       );
//     },
//   );
// }
//
// void showChangePhoneBottomSheet(
//   BuildContext context,
//   String phoneNumberIntl,
// ) {
//   _baseFunction(
//     context: context,
//     builder: (_) {
//       return Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             // ChangePhoneBottomSheet(),
//           ],
//         ),
//       );
//     },
//   );
// }
//
// void showAddToCartBottomSheet(
//   BuildContext context,
//   Product product,
//   AddToCartCallback onAddToCart,
// ) {
//   showMaterialModalBottomSheet(
//     bounce: true,
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: (ctx) => BaseBottomSheet(
//       aboveSheet: product.photo != null
//           ? AspectRatio(
//               aspectRatio: 19 / 12,
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(
//                     topRight: Radius.circular(10),
//                     topLeft: Radius.circular(10),
//                   ),
//                   image: DecorationImage(
//                     image: NetworkImage('${APIs.baseMedia}/${product.photo}'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             )
//           : null,
//       child: AddToCartWidget(
//         productItem: product,
//         onAddToCart: onAddToCart,
//       ),
//     ),
//   );
// }
//
// void _baseFunction({
//   required BuildContext context,
//   required Widget Function(BuildContext) builder,
// }) {
//   showMaterialModalBottomSheet(
//     bounce: true,
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: builder,
//   );
// }
