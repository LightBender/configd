module stdx.config.env;

import stdx.config.base;
import stdx.config.config;

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
		vars = environment.toAA();
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

	auto envPath = config.get!string("env/path");
	assert(envPath != null);
	writeln(envPath);
}