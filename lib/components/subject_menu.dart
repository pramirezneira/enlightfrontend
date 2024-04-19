import 'package:enlight/components/autocomplete_field.dart';
import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/models/category_data.dart';
import 'package:enlight/models/subject_data.dart';
import 'package:enlight/util/teacher_ops.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';

class SubjectMenu extends StatefulWidget {
  final void Function() onPressed;
  final List<CategoryData> categories;
  final List<SubjectData> subjects;

  const SubjectMenu({
    super.key,
    required this.onPressed,
    required this.categories,
    required this.subjects,
  });

  @override
  State<SubjectMenu> createState() => _SubjectMenuState();
}

class _SubjectMenuState extends State<SubjectMenu> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController categoryNameController;
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  var loaded = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    categoryNameController = TextEditingController();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    !loaded
        ? WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              loaded = true;
            });
            showModalBottomSheet<bool>(
              isScrollControlled: true,
              useSafeArea: true,
              context: context,
              builder: (context) => _buildForm(context),
            ).then((pressed) =>
                pressed == true ? _submit() : Navigator.of(context).pop(null));
          })
        : null;
    return const Visibility(
      visible: false,
      child: Placeholder(),
    );
  }

  void _submit() {
    widget.onPressed();
    TeacherOps.createSubject(
      categoryName: categoryNameController.text,
      name: nameController.text,
      description: descriptionController.text,
      price: int.tryParse(priceController.text) ?? 0,
    ).then((code) {
      if (code == 200) {
        widget.subjects.add(
          SubjectData(
            id: 0,
            name: nameController.text,
            description: descriptionController.text,
            categoryId: 0,
            categoryName: categoryNameController.text,
            price: int.tryParse(priceController.text) ?? 0,
          ),
        );
        Navigator.of(context).pop(200);
      } else if (code == 401) {
        Token.refreshAccessToken().then((_) => _submit());
      } else if (code == 500) {
        Navigator.of(context).pop(500);
      } else {
        Navigator.of(context).pop(null);
      }
    });
  }

  Widget _buildForm(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create subject",
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    AutocompleteField(
                      text: "Category Name",
                      data: widget.categories,
                      controller: categoryNameController,
                    ),
                    EnlightTextField(
                      text: "Name",
                      controller: nameController,
                    ),
                    EnlightTextField(
                      text: "Price",
                      controller: priceController,
                      number: true,
                    ),
                    EnlightTextField(
                      text: "Description",
                      controller: descriptionController,
                      description: true,
                    ),
                    FormSubmissionButton(
                      text: "Create",
                      formKey: formKey,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
