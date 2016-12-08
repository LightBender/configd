# configd

configd is a D library that provides a unified storage and retrival API for application configuration information. The configd API is extensible and can support any configuration source that can be mapped to key/value pair.

## Configuration Providers

configd supports the following configuration providers:
- EnvironmentConfig - Loads the applications envirvonment variables under the '/env/' path.
- MemoryConfig - Allows the developer to specify configuration values in code.
- JsonConfig - Loads configuration information from the specified JSON file.

## Example Usage

```
import std.stdio;
import configd;

auto mem = new MemoryConfig("memory");
mem.set("test", "Hello World");

auto config = new Configuration()
	.addJsonConfig("./config.json", "config");
	.addMemoryConfig(mem);
	.addEnvironmentConfig();
config.build();

auto envPath = config.get!string("/env/path");
writeln(envPath);

auto keys = config.listKeys();
foreach(k; keys)
	writeln(k);
```
