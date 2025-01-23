import 'package:flutter/material.dart';
import 'package:sliver_app/model/dicoding_classes.dart';
import 'package:sliver_app/utils/sliver_header_delegate.dart';
import 'package:sliver_app/widget/listtile_item.dart';

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.medium(
            title: Text("Dicoding Learning Path"),
          ),
          _header(context, "Multi-platform Developer"),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTileItem(
                dicodingCourse: multiplatformPath[index],
              ),
              childCount: multiplatformPath.length,
            ),
          ),
          _header(context, "iOS Developer"),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTileItem(
                dicodingCourse: iosPath[index],
              ),
              childCount: iosPath.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
          ),
          _header(context, "Android Developer"),
          SliverList.builder(
            itemCount: androidPath.length,
            itemBuilder: (context, index) => ListTileItem(
              dicodingCourse: androidPath[index],
            ),
          ),
          _header(context, "Front-End Web Developer"),
          SliverGrid.count(
            crossAxisCount: 2,
            children: webPath
                .map((webClass) => ListTileItem(
                      dicodingCourse: webClass,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  SliverPersistentHeader _header(
    BuildContext context,
    String text,
  ) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverHeaderDelegate(
        minHeight: 60,
        maxHeight: 150,
        child: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
