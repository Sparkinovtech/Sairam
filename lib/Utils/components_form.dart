import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ComponentsForm extends StatefulWidget {
  const ComponentsForm({super.key});

  @override
  State<ComponentsForm> createState() => _ComponentsFormState();
}

class _ComponentsFormState extends State<ComponentsForm> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _components = TextEditingController();
  final TextEditingController _quantity  = TextEditingController();
  final TextEditingController _reason = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size =  MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back_ios ,color: Colors.black,)),
                        Text("Components",style: GoogleFonts.lato(color: Colors.black,fontSize: 24,fontWeight: FontWeight.w800),),
                      ],
                    ),
                    SizedBox(height: size.height * .01,),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 20),
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      _componentsField(controller: _id, hintText: "Student Id",
                          validator: (v) => v == null || v.isEmpty ? "Enter the Student Id" : null , text: TextInputType.text),
                      SizedBox(height: size.height * .02,),
                      _componentsField(controller: _components, hintText:"Components",
                          validator: (v) => v == null || v.isEmpty ? "Enter the Components" : null, text: TextInputType.text),
                      SizedBox(height: size.height * .02,),
                      _componentsField(controller: _quantity, hintText: "Quantity",
                          validator: (v) => v == null || v.isEmpty ? "Enter the Quantity" : null , text: TextInputType.number),
                      SizedBox(height: size.height * .02,),
                      _componentsField(controller: _reason, hintText: "Reason", validator: (v) => v == null || v.isEmpty ? "Enter the Reason" : null, text: TextInputType.name),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * .02,),
              Row(
                children: [

                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30 , vertical: 20),
        child: MaterialButton(
          onPressed: (){
            if(_key.currentState!.validate()){
              Navigator.pop(context);
            }
          },
          color: Colors.blue,
          minWidth: double.infinity,
          height: size.height * .07,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("Get Components",style: GoogleFonts.lato(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w800),),
        ),
      ),
    );
  }
  Widget _componentsField({required TextEditingController controller ,
    required String hintText , required String? Function(String?) validator , required TextInputType text}){
     return TextFormField(
       validator: validator,
       keyboardType: text,
       cursorColor: Colors.grey,
       controller: controller,
       decoration: InputDecoration(
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10),
           borderSide: BorderSide.none,
         ),
         hintStyle: GoogleFonts.inter(color: Colors.grey ,fontWeight: FontWeight.w500 , fontSize: 15,),
         hintText: hintText,
         filled: true,
         fillColor: Colors.grey.withOpacity(.1),
       ),
     );
  }
}
