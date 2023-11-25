from conan import ConanFile

class PytorchConan(ConanFile):
    name = "pytorch-conan"
    requires = "abseil/20240116.1@chong/dev", "protobuf/26.0@chong/dev", "onnx/1.15.0@chong/dev", "openssl/3.2.0@chong/dev"
    python_requires = "shell/0.0.1"

    def layout(self):
        self.folders.generators = "generators"

    def generate(self):
        ShellToolchain = self.python_requires["shell"].module.ShellToolchain
        tc = ShellToolchain(self)
        tc.write_export_script()
