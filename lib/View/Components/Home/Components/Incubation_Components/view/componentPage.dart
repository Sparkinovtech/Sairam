import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/bloc/component_bloc.dart';

class Componentpage extends StatefulWidget {
  const Componentpage({super.key});

  @override
  State<Componentpage> createState() => _ComponentpageState();
}

class _ComponentpageState extends State<Componentpage> {
  @override
  void initState() {
    super.initState();
    context.read<ComponentBloc>().add(LoadComponentEvent());
  }

  Widget build(BuildContext context) {
    return BlocConsumer<ComponentBloc, ComponentState>(
      builder: (context, state) {
        return const Placeholder();
      },
      listener: (context, state) {},
    );
  }
}
