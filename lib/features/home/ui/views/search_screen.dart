


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/core/theme/app_colors.dart';
import 'package:note_app/core/widgets/custom_text_form_field.dart';
import 'package:note_app/features/home/ui/cubit/search_cubit.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_card_note.dart';
import 'package:note_app/features/home/ui/views/widgets/custom_header.dart';

import '../cubit/note_cubit.dart';
import '../cubit/search_state.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Padding(
        padding: EdgeInsets.all(22.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppbar(),
            16.verticalSpace,
            _buildSearchField(context),
            Expanded(
              child: _buildMainContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return CustomTextFormField(
      controller: _searchController,
      hintText: "Search",
      hintStyle: TextStyle(
        color: AppColor.textGray,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      ),
      onChanged: (value) {
        context.read<SearchCubit>().updateQuery(value.trim());
        if (value.trim().isEmpty) {
          context.read<NoteCubit>().clearSearch();
        }
      },
      onSubmitted: (value) {
        final query = value.trim();
        if (query.isNotEmpty) {
          // Add to recent searches
          context.read<SearchCubit>().confirmSearch(query);
          // Perform the search
          context.read<NoteCubit>().searchNotes(query);
          // Keep the search text visible
          FocusScope.of(context).unfocus();
        }
      },
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, searchState) {
        final query = searchState.query.trim();

        if (query.isNotEmpty && !searchState.showResults) {
          final filtered = searchState.recentSearches
              .where((s) => s.toLowerCase().contains(query.toLowerCase()))
              .toList();
          if (filtered.isEmpty) {
            return Center(
              child: Text(
                "No recent searches match",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: filtered.length,
            separatorBuilder: (_, __) => 8.verticalSpace,
            itemBuilder: (context, index) {
              final item = filtered[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.history, color: Colors.grey, size: 20.r),
                title: Text(item, style: TextStyle(fontSize: 14.sp)),
                trailing: IconButton(
                  icon: Icon(Icons.close, size: 20.r),
                  onPressed: () =>
                      context.read<SearchCubit>().removeSearch(item),
                ),
                onTap: () {
                  // fill input, confirm search in SearchCubit, and trigger NoteCubit's search
                  _searchController.text = item;
                  context.read<SearchCubit>().confirmSearch(item);
                  context.read<NoteCubit>().searchNotes(item);
                },
              );
            },
          );
        }
        return BlocBuilder<NoteCubit, NoteState>(
          builder: (context, noteState) {
            if (noteState is NoteLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (noteState is NoteSuccess && noteState.notes.isNotEmpty) {
              return ListView.separated(
                itemCount: noteState.notes.length,
                separatorBuilder: (_, __) => 12.verticalSpace,
                itemBuilder: (context, index) =>
                    CustomCardNote(note: noteState.notes[index]),
              );
            }
            return _buildRecentSearchesSection(context);
          },
        );
      },
    );
  }

  Widget _buildRecentSearchesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.verticalSpace,
        _buildRecentSearchesHeader(context),
        16.verticalSpace,
        Expanded(child: _buildRecentSearchesList(context)),
      ],
    );
  }

  Widget _buildRecentSearchesHeader(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final searches = state.recentSearches;
        if (searches.isEmpty) return const SizedBox();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Searches",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.read<SearchCubit>().clearSearches(),
              child: Text(
                "Clear all",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColor.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentSearchesList(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final recentSearches = state.recentSearches;
        if (recentSearches.isEmpty) {
          return Center(
            child: Text(
              "No recent searches to display",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: recentSearches.length,
          itemBuilder: (context, index) {
            final search = recentSearches[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.search, color: Colors.grey, size: 20.r),
              title: Text(search, style: TextStyle(fontSize: 14.sp)),
              trailing: IconButton(
                icon: Icon(Icons.close, size: 20.r),
                onPressed: () => context.read<SearchCubit>().removeSearch(search),
              ),
              onTap: () {
                _searchController.text = search;
                context.read<SearchCubit>().confirmSearch(search);
                context.read<NoteCubit>().searchNotes(search);
              },
            );
          },
        );
      },
    );
  }
}