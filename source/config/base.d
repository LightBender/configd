module stdx.config.base;

import std.string;
import std.algorithm.searching;

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
		if(!pathRoot.toLower().startsWith("/"))
		{
			this._root = "/" ~ pathRoot.toLower();
		}
		else
		{
			this._root = pathRoot.toLower();
		}
	}

	public abstract void load();
	public abstract immutable(string[string]) extract();
}
