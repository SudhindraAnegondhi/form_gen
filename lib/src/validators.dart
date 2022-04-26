const Map<String, String> validatorsMap = {
  'required': '''
       (value.isEmpty) ?  'This field is required' : null;
    ''',
  'email': '''
      value.isEmail ? null : 'Please enter a valid email';
    ''',
  'phone': '''
   !value.isNumeric || value.length != 10 ? 'Please enter a valid phone number' : null;
    ''',
  'numeric': '''
    !value.isNumeric ? 'Please enter a valid number' : null;
     ''',
};