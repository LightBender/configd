module stdx.config.base;

import std.string;

public class ConfigException : Exception
{
	this(string message)
	{
		super(message);
	}
}

public abstract class ConfigBase
{
	private string _root;
	package @property string root() { return _root; }

	protected this(string pathRoot)
	{
		this._root = pathRoot.toLower();
	}

	public abstract void load();
	public abstract immutable(string[string]) extract();
}
