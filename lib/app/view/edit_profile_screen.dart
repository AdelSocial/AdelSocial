import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController(text: "Sophia Miller");
  final TextEditingController emailController = TextEditingController(text: "sophia@example.com");
  final TextEditingController phoneController = TextEditingController(text: "+1 234 567 8900");
  final TextEditingController bioController = TextEditingController(text: "Professional model and content creator");
  final TextEditingController genderController = TextEditingController(text: "Female");
  final TextEditingController dobController = TextEditingController(text: "March 15, 1995");
  final TextEditingController categoryController = TextEditingController(text: "Fashion Model");
  final TextEditingController experienceController = TextEditingController(text: "5 Years");
  final TextEditingController locationController = TextEditingController(text: "New York, USA");
  final TextEditingController languagesController = TextEditingController(text: "English, Spanish");

  String? selectedGender;
  List<String> genderOptions = ["Female", "Male", "Other", "Prefer not to say"];

  @override
  void initState() {
    super.initState();
    selectedGender = genderController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.pink[600]),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.pink[800],
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.pink[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture Section
            _buildProfilePictureSection(),
            const SizedBox(height: 30),

            // Personal Information
            _buildSection(
              title: "Personal Information",
              icon: Icons.person_outline,
              children: [
                _buildTextField(
                  controller: nameController,
                  label: "Full Name",
                  icon: Icons.person,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: emailController,
                  label: "Email Address",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: phoneController,
                  label: "Phone Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),
                _buildDropdownField(
                  label: "Gender",
                  value: selectedGender,
                  items: genderOptions,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                      genderController.text = value!;
                    });
                  },
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: dobController,
                  label: "Date of Birth",
                  icon: Icons.calendar_today,
                  onTap: () => _selectDate(context),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Professional Information
            _buildSection(
              title: "Professional Information",
              icon: Icons.work_outline,
              children: [
                _buildTextField(
                  controller: categoryController,
                  label: "Category",
                  icon: Icons.category,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: experienceController,
                  label: "Experience",
                  icon: Icons.timeline,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: locationController,
                  label: "Location",
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: languagesController,
                  label: "Languages",
                  icon: Icons.language,
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Bio Section
            _buildSection(
              title: "About Me",
              icon: Icons.description_outlined,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: bioController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Bio",
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      hintText: "Tell us about yourself...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.pink[100]!, Colors.pink[300]!],
                ),
                border: Border.all(color: Colors.pink, width: 3),
              ),
              child: ClipOval(
                child: Image.asset(
                  "assets/splash1.jpeg",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.pink[600],
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _changeProfilePicture,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: _changeProfilePicture,
          child: Text(
            "Change Profile Picture",
            style: TextStyle(
              color: Colors.pink[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.pink, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.pink),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.pink),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        icon: Icon(Icons.arrow_drop_down, color: Colors.pink),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.transgender, color: Colors.pink),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              "Save Changes",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[600],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _changeProfilePicture() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Change Profile Picture",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.pink),
                title: Text("Choose from Gallery"),
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'Gallery',
                    'Opening photo gallery...',
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera, color: Colors.pink),
                title: Text("Take Photo"),
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'Camera',
                    'Opening camera...',
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.pink!,
              onPrimary: Colors.white,
              onSurface: Colors.grey[800]!,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _saveProfile() {
    Get.back();
    Get.snackbar(
      'Success',
      'Profile updated successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}