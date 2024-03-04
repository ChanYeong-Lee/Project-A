using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColorHelper
{
    public static Color SetColorAlpha(Color color, float alpha)
    {
        return new Color(color.r, color.g, color.b, alpha);
    }

}
