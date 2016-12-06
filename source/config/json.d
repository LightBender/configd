module stdx.config.json;

import stdx.config.base;
import stdx.config.config;

import std.conv;
import std.stdio;
import stdx.data.json;

public Configuration addJsonConfig(Configuration config, string path, string root)
{
	config.add(new JsonConfig(path, root));
	return config;
}

public final class JsonConfig : ConfigBase
{
	private string path;
	private string[string] elems;

	public this(string path, string root)
	{
		super(root);
		this.path = path;
	}

	public override void load()
	{
		import std.string : strip;
		import std.conv: to;

		auto file = File(path, "r");
		auto buf = file.rawRead(new char[file.size]);
		file.close();

		string json = strip(to!string(buf));
		JSONValue jv = toJSONValue(json);

		parseValues("", jv);
	}

	public override immutable(string[string]) extract()
	{
		import std.exception : assumeUnique;

		return assumeUnique(elems);
	}

	private void parseValues(string refPath, JSONValue value)
	{
		if(value.hasType!(JSONValue[])())
		{
			int c=0;
			auto vl = value.get!(JSONValue[])();
			foreach(v; vl)
			{
				parseValues(refPath ~ "/" ~ to!string(c++), v);
			}
		}
		if(value.hasType!(JSONValue[string])())
		{
			auto vl = value.get!(JSONValue[string])();
			foreach(v; vl.byKeyValue())
			{
				parseValues(refPath ~ "/" ~ v.key, v.value);
			}
		}
		if(value.hasType!(typeof(null))())
		{
			elems[refPath] = to!string(value.get!(typeof(null))());
		}
		if(value.hasType!bool())
		{
			elems[refPath] = to!string(value.get!bool());
		}
		if(value.hasType!string())
		{
			elems[refPath] = to!string(value.get!string());
		}
		if(value.hasType!long())
		{
			elems[refPath] = to!string(value.get!long());
		}
		if(value.hasType!double())
		{
			elems[refPath] = to!string(value.get!double());
		}
	}
}

unittest
{
	import std.file;
	import std.path;

	string filePath = buildNormalizedPath(getcwd(), "jsonConfigTest.json");
	if(exists(filePath))
	{
		remove(filePath);
	}

	write(filePath, "{\"Logging\": { \"IncludeScopes\": false, \"LogLevel\": { \"Default\": \"Debug\", \"System\": \"Information\", \"Microsoft\": \"Information\" } } }");

	auto config = new Configuration()
		.addJsonConfig(filePath, "config");
	config.build();

	auto keys = config.listKeys();
	foreach(k; keys)
		writeln(k);

	auto keys2 = config.listKeys("/config/logging");
	foreach(k; keys2)
		writeln(k);

	auto envPath = config.get!string("/config/logging/includescopes");
	assert(envPath != null);
	writeln(envPath);

	remove(filePath);
}
