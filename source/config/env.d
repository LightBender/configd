module configd.env;

import configd.base;
import configd.config;

import std.process;

public Configuration addEnvironmentConfig(Configuration config)
{
	config.add(new EnvironmentConfig());
	return config;
}

public final class EnvironmentConfig : ConfigBase
{
	private string[string] vars;

	public this()
	{
		super("env");
	}

	public override void load()
	{
		auto env = environment.toAA();
		foreach(e; env.byKeyValue())
		{
			vars["/" ~ e.key] = e.value;
		}
	}

	public override immutable(string[string]) extract()
	{
		import std.exception : assumeUnique;

		return assumeUnique(vars);
	}
}

unittest
{
	import std.stdio;

	auto config = new Configuration()
		.addEnvironmentConfig();
	config.build();

	auto keys = config.listKeys();
	foreach(k; keys)
		writeln(k);

	auto envPath = config.get!string("/env/path");
	assert(envPath != null);
	writeln(envPath);
}