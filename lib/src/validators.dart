
const Map<String, String> validatorsMap = {
  'required': '''
        ( value != null && value.isEmpty) ?  'This field is required' : null;
     ''',

  'email': '''
      (value != null && value.isEmail ) ? null : 'Please enter a valid email';
    ''',
  'phone': '''
   (value != null && value.isNumeric  ? 'Please enter a valid phone number' : null;
    ''',
  'numeric': '''
     (value?.isNumeric ?? false) == false ? 'Please enter a valid number' : null;
     ''',
  'date': '''
      (value?.isEmpty ?? false)  || !(value?.isDate ?? false) ? 'Please enter a valid date' : null;
    ''',
  'name': '''
      (value?.isEmpty ?? false)  || !(value?.isName ?? false) ? 'Please enter a valid name' : null;
    ''',
  'min': '''
      (arg) => (value?.isEmpty ?? false)  || (value?.length ?? 0) < arg ? 'Please enter a value greater than or equal to \${arg}' : null;
    ''',
  'max': '''
      (arg) => (value?.isEmpty ?? false)  || (value?.length ?? 0) > arg ? 'Please enter a value less than or equal to \${arg}' : null;
    ''',
  'fixedLength': '''
   (arg) => (value?.length ?? 0) != arg ? 'Please enter a valid length' : null;
    ''',
  'minLength': '''
    (arg) => (value?.length ?? 0) < arg ? 'Please enter a valid length' : null;
      ''',
  'maxLength': '''
    (arg) => (value?.length ?? 0) > arg ? 'Please enter a valid length' : null;
      ''',
  'range': '''
    (arg) => (value?.isEmpty ?? false)  || (value?.length ?? 0) < arg || (value?.length ?? 0) > arg2 ? 'Please enter a value between \${arg,split(':').first} and \$[arg,split(':').last}' : null;
      ''',
};
