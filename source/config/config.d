module stdx.config.config;

import stdx.config.base;

import std.algorithm.searching;
import std.array;
import std.conv;
import std.string;
import std.traits;

public class Configuration
{
	private ConfigBase[] _providers;
	private string[string] values;

	public this()
	{
		_providers.reserve(8);
	}

	public void add(ConfigBase provider)
	{
		_providers ~= provider;
	}

	public void build()
	{
		import std.stdio: writefln;

		foreach(provider; _providers)
		{
			provider.load();
			auto config = provider.extract();

			foreach(value; config.byKeyValue())
			{
				values[provider.root() ~ value.key.toLower()] = value.value;
			}
		}

		values.rehash();
	}

	public T get(T)(string path)
		if(isScalarType!(T) || isSomeString!(T))
	{
		auto lowerPath = path.toLower();
		if(lowerPath in values)
		{
			return to!T(values[lowerPath]);
		}
		else
		{
			throw new ConfigException("Unable to locate configuration path: " ~ lowerPath);
		}
	}

	public string[] listKeys(string basePath = null)
	{
		if(basePath is null || basePath == "")
		{
			basePath = "/";
		}
		if(!basePath.startsWith("/"))
		{
			basePath = "/" ~ basePath;
		}

		auto keys = appender!(string[])();
		int c = 0;
		foreach(k; values.byKey())
		{
			if(k.startsWith(basePath) || k == basePath)
			{
				if(basePath == "/")
				{
					keys.put(k);
				}
				else
				{
					keys.put(k[basePath.length..$]);
				}
			}
		}

		return keys.data;
	}
}