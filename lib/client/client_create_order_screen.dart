import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ClientCreateOrderScreen extends StatefulWidget {
  const ClientCreateOrderScreen({super.key});

  @override
  State<ClientCreateOrderScreen> createState() => _ClientCreateOrderScreenState();
}

class _ClientCreateOrderScreenState extends State<ClientCreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> formData = {
    'fullName': '',
    'email': '',
    'phone': '',
    'linkedin': '',
    'city': '',
    'country': '',
    'qualification': '',
    'education': <Map<String, String>>[],
    'experience': <Map<String, String>>[],
    'skills': <String>[],
    'languages': <String>[],
    'certifications': <String>[],
    'achievements': <String>[],
    'projects': <String>[],
    'notes': '',
  };

  final TextEditingController skillCtrl = TextEditingController();
  final TextEditingController langCtrl = TextEditingController();
  final TextEditingController certCtrl = TextEditingController();
  final TextEditingController achCtrl = TextEditingController();
  final TextEditingController projCtrl = TextEditingController();
  final TextEditingController notesCtrl = TextEditingController();

  final fieldFill = const Color(0xFF1A1A1A);
  final mainColor = const Color(0xFF5C7AFF);

  void addEducation() {
    setState(() {
      formData['education'].add({'field': '', 'university': '', 'start': '', 'end': ''});
    });
  }

  void addExperience() {
    setState(() {
      formData['experience'].add({'title': '', 'company': '', 'start': '', 'end': ''});
    });
  }

  Future<void> submitOrder() async {
    _formKey.currentState!.save();
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting order...')),
      );
      await ApiService.createOrder(formData);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Order submitted successfully!')),
      );
      setState(() {
        formData.updateAll((key, value) => value is List ? [] : '');
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to submit order: $e')),
      );
    }
  }

  Widget _buildTextField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: fieldFill,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        style: const TextStyle(color: Colors.white),
        onSaved: (v) => formData[key] = v ?? '',
      ),
    );
  }

  Widget _buildChipsSection(String title, String key, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: ctrl,
                decoration: InputDecoration(
                  labelText: hint,
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: fieldFill,
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
                onEditingComplete: () {
                  final text = ctrl.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      formData[key].add(text);
                      ctrl.clear();
                    });
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: mainColor),
              onPressed: () {
                final text = ctrl.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    formData[key].add(text);
                    ctrl.clear();
                  });
                }
              },
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final v in formData[key])
              Chip(
                backgroundColor: fieldFill,
                label: Text(v, style: const TextStyle(color: Colors.white)),
                deleteIconColor: Colors.redAccent,
                onDeleted: () => setState(() => formData[key].remove(v)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Education"),
        for (int i = 0; i < formData['education'].length; i++)
          _buildCard([
            _eduField(i, 'field', 'Field of Study'),
            _eduField(i, 'university', 'University'),
            _eduField(i, 'start', 'Start Date'),
            _eduField(i, 'end', 'End Date'),
          ]),
        addButton("Add Education", addEducation),
      ],
    );
  }

  Widget _buildExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Work Experience"),
        for (int i = 0; i < formData['experience'].length; i++)
          _buildCard([
            _expField(i, 'title', 'Job Title'),
            _expField(i, 'company', 'Company'),
            _expField(i, 'start', 'Start Date'),
            _expField(i, 'end', 'End Date'),
          ]),
        addButton("Add Experience", addExperience),
      ],
    );
  }

  Widget sectionTitle(String text) => Text(text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white));

  Widget _buildCard(List<Widget> children) => Card(
        color: fieldFill,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: children),
        ),
      );

  Widget _eduField(int i, String field, String label) =>
      _miniField((v) => formData['education'][i][field] = v, label);

  Widget _expField(int i, String field, String label) =>
      _miniField((v) => formData['experience'][i][field] = v, label);

  Widget _miniField(ValueChanged<String> onChanged, String label) => TextFormField(
        decoration: InputDecoration(labelText: label),
        onChanged: onChanged,
      );

  Widget addButton(String text, VoidCallback action) => TextButton.icon(
        onPressed: action,
        icon: Icon(Icons.add, color: mainColor),
        label: Text(text, style: const TextStyle(color: Colors.white)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Create Your CV Order',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),

              _buildTextField('fullName', 'Full Name'),
              _buildTextField('email', 'Email'),
              _buildTextField('phone', 'Phone'),
              _buildTextField('linkedin', 'LinkedIn'),
              _buildTextField('city', 'City'),
              _buildTextField('country', 'Country'),
              _buildTextField('qualification', 'Highest Qualification'),

              const SizedBox(height: 20),
              _buildEducationSection(),
              const SizedBox(height: 20),
              _buildExperienceSection(),

              _buildChipsSection('Skills', 'skills', skillCtrl, 'Add Skill'),
              _buildChipsSection('Languages', 'languages', langCtrl, 'Add Language'),
              _buildChipsSection('Certifications', 'certifications', certCtrl, 'Add Certification'),
              _buildChipsSection('Achievements', 'achievements', achCtrl, 'Add Achievement'),
              _buildChipsSection('Projects', 'projects', projCtrl, 'Add Project'),

              const SizedBox(height: 20),
              sectionTitle("Additional Notes"),
              TextField(
                controller: notesCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Any extra info...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: fieldFill,
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (v) => formData['notes'] = v,
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                  onPressed: submitOrder,
                  child: const Text('Submit Order'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}




