module.exports = {
  root: true,
  extends: '@react-native',
  overrides: [
    {
      files: ['src/specs/**/*.ts', 'src/specs/**/*.tsx'],
      rules: {
        '@react-native/no-deep-imports': 'off',
      },
    },
  ],
};
