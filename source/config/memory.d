module stdx.config.memory;

import std.string;
import stdx.config.base;
import stdx.config.config;

public Configuration addMemoryConfig(Configuration config, MemoryConfig memory)
{
	config.add(memory);
	return config;
}

public final class MemoryConfig : ConfigBase
{
	private string[string] elems;

	public this(string pathRoot)
	{
		super(pathRoot.toLower());
	}

	public void set(string path, string value)
	{
		if(!path.startsWith("/"))
		{
			path = "/" ~ path;
		}

		elems[path.toLower()] = value;
	}

	public override void load() { }

	public override immutable(string[string]) extract()
	{
		import std.exception : assumeUnique;

		return assumeUnique(elems);
	}
}

unittest
{
	import std.stdio : writeln;

	auto mem = new MemoryConfig("memory");
	mem.set("test", "Hello World");

	auto config = new Configuration()
		.addMemoryConfig(mem);
	config.build();

	auto keys = config.listKeys();
	foreach(k; keys)
		writeln(k);

	auto test = config.get!string("/memory/test");
	assert(test != null);
	writeln(test);
}