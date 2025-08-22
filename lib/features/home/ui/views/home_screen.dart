import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/core/utils/extensions/navigation_extensions.dart';
import 'package:note_app/features/home/ui/cubit/navigation_cubit.dart';
import 'package:note_app/features/add_edit/ui/views/add_note.dart';
import 'package:note_app/features/favorites/ui/views/favorite_screen.dart';
import 'package:note_app/features/hidden/ui/views/hidden_screen.dart';
import 'package:note_app/features/Search/ui/views/search_screen.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_card_note.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_grid_view.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_header.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_recent_note.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../deleted/ui/cubit/deleted_cubit.dart';
import '../../data/repos/note_repo_imp.dart';
import '../cubit/note_cubit.dart';
import '../../../Search/ui/cubit/search_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
  builder: (context, currentTab) {
    return BlocConsumer<NoteCubit, NoteState>(
      listener: (context, state) {
        if(state is NoteDeleteSuccess){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Note deleted successfully!"),
                backgroundColor: AppColor.primaryColor,
              ),
          );
        }else if (state is NoteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: IndexedStack(
            index: currentTab,
            children: [
              RefreshIndicator(
                backgroundColor: AppColor.primaryColor,
                color: AppColor.white,
                displacement: 10,
                strokeWidth: 2,
                onRefresh: () async {
                  context.read<NoteCubit>().getAllNotes();
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(22.0.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomAppbar(),
                        16.verticalSpace,
                        CustomTextFormField(
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: AppColor.textGray,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          onChanged: (value) {
                            context.read<SearchCubit>().confirmSearch(value);
                            context.read<NoteCubit>().searchNotes(value);
                          },
                        ),
                        22.verticalSpace,
                        CustomGridView(),
                        20.verticalSpace,
                        BlocBuilder<NoteCubit,NoteState>(
                            builder: (context,state) {
                              final cubit = context.read<NoteCubit>();
                              if (state is NoteLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is NoteError) {
                                return Center(
                                  child: Text(
                                    state.message,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                );
                              }
                              if(state is NoteSuccess){
                                return Column(
                                  children: [
                                    if (state.notes.isNotEmpty)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Recent Notes",style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold,),),
                                          16.verticalSpace,
                                          SizedBox(
                                            height: 198.h,
                                            width: MediaQuery.sizeOf(context).width,
                                            child: ListView.separated(
                                              itemBuilder: (context,index) => CustomRecentNote(
                                                isSelected: index == 0,
                                                title: state.notes[index].title,
                                                description: state.notes[index].content,
                                              ),
                                              separatorBuilder: (context, index) => SizedBox(width: 12.w,),
                                              itemCount: state.notes.length,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.horizontal,

                                            ),
                                          )
                                        ],
                                      ),
                                    12.verticalSpace,
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context,index) => InkWell(
                                        onTap: (){
                                          context.pushNamed(
                                            Routes.editNoteScreen,
                                            arguments: state.notes[index],
                                          );
                                        },
                                        child: CustomCardNote(note: state.notes[index]),
                                      ),
                                      separatorBuilder: (context, index) => 12.verticalSpace,
                                      itemCount: state.notes.length,
                                    )
                                  ],
                                );
                              }
                              return SizedBox();
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const HiddenNotesScreen(),
               SearchScreen(),
               AddNote(),
            ],
          ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: AppColor.primaryColor,
          //   shape: CircleBorder(),
          //   tooltip: "Add Note",
          //   onPressed: () {
          //     context.pushNamed(Routes.addNote);
          //   },
          //   child: Icon(Icons.note_add_outlined, color: AppColor.white),
          // ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentTab,
            onTap: (index) => context.navigateToTab(index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColor.primaryColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.note_outlined),
                label: 'Notes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: 'Event',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note_add_outlined),
                label: 'Create Note',
              ),
            ],
          ),
        );
      },
    );
  },
);
  }
}

