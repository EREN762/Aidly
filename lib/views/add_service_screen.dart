import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../models/service_model.dart';
import '../providers/auth_provider.dart';
import '../providers/service_provider.dart';
import 'widgets/app_spacing.dart';
import 'widgets/custom_button.dart';
import 'widgets/input_field.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _subCategoryController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  late final String _serviceId;
  int _currentStep = 0;
  bool _isSubmitting = false;
  bool _isUploading = false;
  XFile? _pickedImage;
  String? _uploadedUrl;
  String? _selectedCategory;
  String? _selectedSubCategory;

  final Map<String, List<String>> _categoryOptions = const {
    'Bricolage': ['Plomberie', 'Electricite', 'Menuiserie', 'Peinture'],
    'Jardinage': ['Tonte', 'Paysagisme', 'Arrosage', 'Entretien'],
    'Cours particuliers': ['Maths', 'Langues', 'Informatique', 'Musique'],
    'Menage': ['Nettoyage', 'Repassage', 'Organisation'],
    'Demarche et courses': ['Courses', 'Livraison', 'Administratif'],
    'Demenagement': ['Transport', 'Emballage', 'Manutention'],
  };

  @override
  void initState() {
    super.initState();
    _serviceId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _subCategoryController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    if (!_formKey.currentState!.validate()) return false;
    return true;
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (file == null) return;

    setState(() {
      _pickedImage = file;
      _isUploading = true;
    });

    try {
      final provider = Provider.of<ServiceProvider>(context, listen: false);
      final url = await provider.uploadServiceImage(
        file: File(file.path),
        serviceId: _serviceId,
      );
      if (!mounted) return;
      setState(() {
        _uploadedUrl = url;
        _imageUrlController.text = url;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur upload: $error')),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _submit() async {
    if (!_validateCurrentStep()) return;
    setState(() => _isSubmitting = true);
    try {
      final provider = Provider.of<ServiceProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authController = AuthController(authProvider);
      final userId = authController.currentUserId ?? '';
      final now = DateTime.now();
      final service = ServiceModel(
        id: _serviceId,
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
        subCategory: _subCategoryController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0,
        imageUrl: _imageUrlController.text.trim(),
        imageProfileUrl: '',
        rating: 0,
        reviewsCount: 0,
        createdAt: now,
        updatedAt: now,
        createdBy: userId,
        updatedBy: userId,
      );
      await provider.createService(service);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur creation: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un service'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Stepper(
            currentStep: _currentStep,
            type: StepperType.vertical,
            onStepContinue: () {
              if (!_validateCurrentStep()) return;
              if (_currentStep < 2) {
                setState(() => _currentStep += 1);
              } else {
                _submit();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: _currentStep == 2
                            ? 'Publier le service'
                            : 'Continuer',
                        isLoading: _isSubmitting,
                        onPressed: details.onStepContinue,
                      ),
                    ),
                    if (_currentStep > 0) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          label: 'Retour',
                          variant: ButtonVariant.outline,
                          onPressed: details.onStepCancel,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text('Infos principales'),
                isActive: _currentStep >= 0,
                content: Padding(
                  padding: AppSpacing.screen.copyWith(top: 0),
                  child: Column(
                    children: [
                      InputField(
                        label: 'Titre du service',
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Titre requis';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Categorie',
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: _categoryOptions.keys
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                            _categoryController.text = value ?? '';
                            final subOptions =
                                _categoryOptions[value] ?? const [];
                            if (!subOptions.contains(_selectedSubCategory)) {
                              _selectedSubCategory = null;
                              _subCategoryController.text = '';
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Categorie requise';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedSubCategory,
                        decoration: const InputDecoration(
                          labelText: 'Sous-categorie',
                          prefixIcon: Icon(Icons.tune),
                        ),
                        items: (_categoryOptions[_selectedCategory] ?? const [])
                            .map(
                              (sub) => DropdownMenuItem(
                                value: sub,
                                child: Text(sub),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSubCategory = value;
                            _subCategoryController.text = value ?? '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Sous-categorie requise';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        label: 'Localisation',
                        controller: _locationController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Localisation requise';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        label: 'Prix (FC)',
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Prix requis';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: const Text('Details'),
                isActive: _currentStep >= 1,
                content: Padding(
                  padding: AppSpacing.screen.copyWith(top: 0),
                  child: Column(
                    children: [
                      InputField(
                        label: 'Description',
                        controller: _descriptionController,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Description requise';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Image du service',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              label: _isUploading
                                  ? 'Upload en cours...'
                                  : 'Uploader une image',
                              icon: Icons.cloud_upload_outlined,
                              isLoading: _isUploading,
                              onPressed:
                                  _isUploading ? null : _pickAndUploadImage,
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (_pickedImage != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_pickedImage!.path),
                                height: 54,
                                width: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                      if (_uploadedUrl != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Image envoyee',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF2AB38A),
                              ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      InputField(
                        label: 'Image (URL)',
                        controller: _imageUrlController,
                        keyboardType: TextInputType.url,
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: const Text('Validation'),
                isActive: _currentStep >= 2,
                content: Padding(
                  padding: AppSpacing.screen.copyWith(top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Verifiez vos informations avant publication.'),
                      const SizedBox(height: 16),
                      _SummaryRow(label: 'Titre', value: _titleController.text),
                      _SummaryRow(
                        label: 'Categorie',
                        value: _categoryController.text,
                      ),
                      _SummaryRow(
                        label: 'Sous-cat',
                        value: _subCategoryController.text,
                      ),
                      _SummaryRow(
                        label: 'Lieu',
                        value: _locationController.text,
                      ),
                      _SummaryRow(
                        label: 'Prix',
                        value: '${_priceController.text} FC',
                      ),
                      _SummaryRow(
                        label: 'Description',
                        value: _descriptionController.text,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6A7C76),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
