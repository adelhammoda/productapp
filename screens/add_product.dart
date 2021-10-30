
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/utils/my_icons_icons.dart';
import 'package:product_app/widgets/app_bar.dart';
import 'package:responsive_s/responsive_s.dart';

class AddProduct extends StatefulWidget {
  final bool add;
  final RepositoryProduct? product;

  const AddProduct({Key? key, required this.add, this.product})
      : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late Responsive _responsive;
  String? _value;
  final List<String> _units=[
    'kilo',
    'later',
    'ton',
    'millimeter',
  ];

  void _addTypes() {
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      _responsive.responsiveValue(forUnInitialDevices: 5))),
              child: SizedBox(
                height: _responsive.responsiveHeight(forUnInitialDevices: 30),
                child: Padding(
                  padding: EdgeInsets.all(
                      _responsive.responsiveValue(forUnInitialDevices: 3)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildTextField('Name', const Icon(Icons.edit), 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                //TODO:add the value to type list here.
                                Navigator.of(context).pop();
                              },
                              child: const Text('Done')),
                          SizedBox(
                            width: _responsive.responsiveWidth(
                                forUnInitialDevices: 5),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor:
                  SettingBlocProvider.of(context).theme.canvasColor,
              elevation: 10,
            ));
  }

  //TODO:add init state and initial some value.
  @override
  Widget build(BuildContext context) {
    _responsive = Responsive(context);
    return Scaffold(
      appBar: buildAppBar(context, title: widget.add?'Add':'Edit',leading:  IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          FocusScope.of(context).unfocus();
          ZoomDrawer.of(context)!.toggle();
        },
      )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
                _responsive.responsiveWidth(forUnInitialDevices: 5)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildImage(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: _buildTextField('name',
                          const Icon(Icons.drive_file_rename_outline), 30),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: _responsive.responsiveValue(
                              forUnInitialDevices: 5)),
                      child: DropdownButton<String>(
                        alignment: Alignment.centerLeft,
                        iconEnabledColor:
                            SettingBlocProvider.of(context).theme.cardColor,
                        items: [
                          const DropdownMenuItem(
                            child: Text('tepee'),
                            value: 'hh',
                          ),
                          const DropdownMenuItem(
                            child: Text('teepee'),
                            value: 'retype',
                          ),
                          DropdownMenuItem(
                            child: IconButton(
                              onPressed: _addTypes,
                              icon: const Icon(Icons.add),
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(15),
                        dropdownColor:
                            SettingBlocProvider.of(context).theme.cardColor,
                        onChanged: (value) {
                          setState(() {
                          _value = value;
                          });
                        },
                        underline: Container(),
                        value: _value,
                        hint: Text(
                          'type',
                          style: TextStyle(
                              color: SettingBlocProvider.of(context)
                                  .theme
                                  .cardColor),
                        ),
                        elevation: 10,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: _responsive.responsiveHeight(forUnInitialDevices: 3),
                ),
                Row(
                  children: [
                    _buildButtons(
                        const Icon(
                          Icons.add,
                          color: Colors.green,
                        ), () {
                      //TODO:add increment logic here.
                    }),
                    SizedBox(
                        width: _responsive.responsiveWidth(
                            forUnInitialDevices: 30),
                        child: _buildTextField('count', null, 15,inputType: TextInputType.number)),
                    _buildButtons(
                        const Icon(
                          MyIcons.minus,
                          color: Colors.red,
                        ), () {
                      //TODO:add decrease logic here.
                    }),
                    Container(
                        decoration: BoxDecoration(
                            color:
                                SettingBlocProvider.of(context).theme.textColor,
                            borderRadius: BorderRadius.circular(_responsive
                                .responsiveValue(forUnInitialDevices: 4))),
                        width: _responsive.responsiveWidth(
                            forUnInitialDevices: 30),
                        height: _responsive.responsiveHeight(
                            forUnInitialDevices: 10),
                        child: ListWheelScrollView(
                          onSelectedItemChanged: (value){
                          },
                          physics: const FixedExtentScrollPhysics(),
                          itemExtent: _responsive.responsiveHeight(
                              forUnInitialDevices: 6),
                          children:_units.map((unit) => Text(
                            unit,
                            style: TextStyle(
                                color: SettingBlocProvider.of(context)
                                    .theme
                                    .focusColor),
                          ) ).toList(),
                        ))
                  ],
                ),
                SizedBox(
                  height: _responsive.responsiveHeight(forUnInitialDevices: 3),
                ),
                Align(alignment: Alignment.bottomRight,child: ElevatedButton(onPressed: (){}, child: const Text('Done')))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Widget? icon, int maxLength,
      {TextEditingController? controller, FocusNode? node,TextInputType? inputType}) {
    return TextField(
      focusNode: node,
      controller: controller,
      keyboardType:inputType,
      maxLength: maxLength,
      maxLines: 1,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(
          color: SettingBlocProvider.of(context).theme.secondaryColor),
      decoration: InputDecoration(
          labelText: label,
          icon: icon,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: SettingBlocProvider.of(context).theme.accentColor))),
    );
  }

  Widget _buildImage() {
    return GestureDetector(
      onTap: (){
        //TODO:add image form device and upload it on cloud.
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            _responsive.responsiveValue(forUnInitialDevices: 6)),
        child: SizedBox(
          width: _responsive.responsiveWidth(forUnInitialDevices: 100),
          height: _responsive.responsiveHeight(forUnInitialDevices: 30),
          child: FadeInImage(
              fit: BoxFit.fill,
              width: _responsive.responsiveWidth(forUnInitialDevices: 40),
              height: _responsive.responsiveHeight(forUnInitialDevices: 10),
              fadeInDuration: const Duration(milliseconds: 400),
              fadeOutCurve: Curves.easeInSine,
              imageErrorBuilder: (context, object, stack) => FittedBox(
                  fit: BoxFit.fill,
                  child: GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/error.png',
                    ),
                  )),
              placeholder: const AssetImage('assets/images/placeholder.png'),
              image: NetworkImage(
                  widget.product == null ? '' : widget.product!.imageURL)),
        ),
      ),
    );
  }

  Widget _buildButtons(Widget child, void Function()? onTap) => MaterialButton(
        onPressed: onTap,
        child: child,
        padding: EdgeInsets.zero,
        height: _responsive.responsiveHeight(forUnInitialDevices: 3),
        minWidth: _responsive.responsiveWidth(forUnInitialDevices: 3),
      );
}
