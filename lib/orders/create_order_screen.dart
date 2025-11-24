import 'package:flutter/material.dart';
import '../services/api.dart';
import 'order.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final formKey = GlobalKey<FormState>();
  final model = OrderModel();

  // 🎨 الثيم المستخدم في كل الصفحات
  final Color bg = const Color(0xFF0D0D0D);
  final Color card = const Color(0xFF1A1A1A);
  final Color field = const Color(0xFF141821);
  final Color mainColor = const Color(0xFF5C7AFF);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          'Create Your Order',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _field('Full Name', (v) => model.contact.fullName = v),
              _field('Email', (v) => model.contact.email = v),
              _field('Phone Number', (v) => model.contact.phone = v),
              _field('LinkedIn Link', (v) => model.contact.linkedin = v),
              _field('City', (v) => model.contact.city = v),
              _field('Country', (v) => model.contact.country = v),
              _field('Highest Qualification', (v) => model.contact.highestQualification = v),

              const SizedBox(height: 20),

              _section('Education', model.education, buildEdu),
              _section('Work Experience', model.experience, buildExp),
              _section('Skills', model.skills, buildSkill),
              _section('Languages', model.languages, buildLang),
              _section('Achievements & Awards', model.achievements, buildGeneric),
              _section('Certifications & Courses', model.certifications, buildGeneric),
              _section('Projects', model.projects, buildGeneric),

              _field('Additional Notes', (v) => model.notes = v, maxLines: 4),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    formKey.currentState!.save();

                    final res = await Api.dio.post('/orders', data: model.toJson());
                    final id = res.data['_id'];

                    await Api.dio.post('/orders/$id/pay');

                    if (mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('Paid & Submitted')),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text(
                    'Pay \$10 and Submit Order',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ============================
  // 🎨 Text field موحد
  Widget _field(String label, Function(String) on,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: field,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onSaved: (v) => on(v ?? ''),
      ),
    );
  }

  // ============================
  // 🎨 Section موحد
  Widget _section(String title, List<SubDoc> list,
      Widget Function(SubDoc, VoidCallback) builder) {
    return Card(
      color: card,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () =>
                      setState(() => list.add(SubDoc())),
                  icon: Icon(Icons.add_circle, color: mainColor),
                )
              ],
            ),
            for (final item in list)
              builder(item, () {
                setState(() => list.remove(item));
              }),
          ],
        ),
      ),
    );
  }

  // ============================
  // 🎨 Card داخلي داخل القسم
  Widget _innerCard(List<Widget> children, VoidCallback remove) {
    return Card(
      color: field,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ...children,
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: remove,
                child: const Text('Remove',
                    style: TextStyle(color: Colors.redAccent)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ============ Builders =============
  Widget buildEdu(SubDoc m, VoidCallback remove) => _innerCard([
        _innerField('Field of Study', (v) => m.fieldOfStudy = v),
        _innerField('University', (v) => m.university = v),
        _innerField('Start (YYYY-MM)', (v) => m.startDate = DateTime.tryParse('$v-01')),
        _innerField('End (YYYY-MM)', (v) => m.endDate = DateTime.tryParse('$v-01')),
      ], remove);

  Widget buildExp(SubDoc m, VoidCallback remove) => _innerCard([
        _innerField('Company', (v) => m.company = v),
        _innerField('Title', (v) => m.title = v),
        _innerField('Start (YYYY-MM)', (v) => m.startDate = DateTime.tryParse('$v-01')),
        _innerField('End (YYYY-MM)', (v) => m.endDate = DateTime.tryParse('$v-01')),
        _innerField('Description', (v) => m.description = v, maxLines: 3),
      ], remove);

  Widget buildSkill(SubDoc m, VoidCallback remove) =>
      _innerCard([
        _innerField('Skill', (v) => m.title = v),
        _innerField('Level', (v) => m.level = v),
      ], remove);

  Widget buildLang(SubDoc m, VoidCallback remove) =>
      _innerCard([
        _innerField('Language', (v) => m.title = v),
        _innerField('Level', (v) => m.level = v),
      ], remove);

  Widget buildGeneric(SubDoc m, VoidCallback remove) =>
      _innerCard([
        _innerField('Title', (v) => m.title = v),
        _innerField('Description/Notes', (v) => m.description = v, maxLines: 3),
      ], remove);

  Widget _innerField(String label, Function(String) on,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF10131A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onSaved: (v) => on(v ?? ''),
      ),
    );
  }
}

