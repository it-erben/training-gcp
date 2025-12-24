const {
    createRequire,
} = require("node:module");

// Resolve ESLint helpers from the working directory so subpackages work.
const requireFromCwd = createRequire(process.cwd() + "/");

const {
    defineConfig,
} = requireFromCwd("eslint/config");

const globals = requireFromCwd("globals");
const js = requireFromCwd("@eslint/js");

const {
    FlatCompat,
} = requireFromCwd("@eslint/eslintrc");

const compat = new FlatCompat({
    baseDirectory: __dirname,
    recommendedConfig: js.configs.recommended,
    allConfig: js.configs.all
});

module.exports = defineConfig([{
    languageOptions: {
        globals: {
            ...globals.browser,
            ...globals.mocha,
            ...globals.node,
        },

        ecmaVersion: 2021,
        parserOptions: {},
    },

    extends: compat.extends("eslint:recommended"),
}]);
