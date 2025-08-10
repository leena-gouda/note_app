import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/features/home/ui/views/favorite_screen.dart';
import 'package:note_app/features/home/ui/views/hidden_screen.dart';

import '../../../data/models/card_model.dart';
import '../deleted_note.dart';
import '../home_screen.dart';
import 'custom_card.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.8,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.h,
      ),
      itemCount: cardList.length,
      itemBuilder:(BuildContext context, int index) =>
          CustomCard(
            cardModel: cardList[index],
            onTap: (){
              switch (index) {
                case 0:
                  Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                  break;
                case 1:
                  Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesScreen()));
                  break;
                case 2:
                  Navigator.push(context, MaterialPageRoute(builder: (_) => HiddenNotesScreen()));
                  break;
                case 3:
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DeletedNotesScreen()));
                  break;
                default:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${cardList[index].title} clicked (not implemented)")),
                  );
              }
            },
          ),
    );
  }
}