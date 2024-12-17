from conan import ConanFile

class PytorchConan(ConanFile):
    name = "pytorch-conan"
    requires = "abseil/20250127.1@chong/dev", "protobuf/30.1@chong/dev", "onnx/1.17.0@chong/dev", "openssl/3.3.3@chong/dev"
    python_requires = "shell/0.0.9"

    def layout(self):
        self.folders.generators = "generators"

    def generate(self):
        ShellToolchain = self.python_requires["shell"].module.ShellToolchain
        tc = ShellToolchain(self)
        tc.write_export_script()
