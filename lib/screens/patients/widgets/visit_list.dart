// import 'package:flutter/material.dart';
//
// import 'package:hospital/models/visits_model.dart';
//
//
// class VisitList extends StatelessWidget {
//   const VisitList({super.key, required this.visits});
//
//   final List<Visit> visits;
//
//   @override
//   Widget build(BuildContext context) {
//     if (visits.isEmpty) {
//       return Center(
//         child: Text(
//           'No visit added yet',
//           style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//             color: Theme.of(context).colorScheme.onBackground,
//           ),
//         ),
//       );
//     }
//
//     return ListView.builder(
//       itemCount: visits.length,
//       itemBuilder: (ctx, index) => ListTile(
//         leading: CircleAvatar(
//           radius: 26,
//           //backgroundImage: FileImage(visits[index].image),
//         ),
//         title: Text(
//           visits[index].name,
//           style: Theme.of(context).textTheme.titleMedium!.copyWith(
//             color: Theme.of(context).colorScheme.onBackground,
//           ),
//         ),
//         subtitle: Text(
//           visits[index].staffName,
//           style: Theme.of(context).textTheme.bodySmall!.copyWith(
//             color: Theme.of(context).colorScheme.onBackground,
//           ),
//         ),
//         // onTap: () {
//         //   Navigator.of(context).push(
//         //     MaterialPageRoute(
//         //       builder: (ctx) => PlaceDetailScreen(place: places[index]),
//         //     ),
//         //   );
//         // },
//       ),
//     );
//   }
// }