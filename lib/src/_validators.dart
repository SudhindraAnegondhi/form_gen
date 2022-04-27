const Map<String, String> validatorsMap = {
  'required': '''
       (value?.isEmpty ?? false) ?  'This field is required' : null;
    ''',
  'email': '''
      (value?.isEmail ?? false )? null : 'Please enter a valid email';
    ''',
  'phone': '''
   (value?.isNumeric ?? false) == false || (value?.length ?? 0) != 10 ? 'Please enter a valid phone number' : null;
    ''',
  'numeric': '''
     (value?.isNumeric ?? false) == false ? 'Please enter a valid number' : null;
     ''',
  'fixedLength': '''
   (length) => (value?.length ?? 0) != length ? 'Please enter a valid length' : null;
    ''',
};