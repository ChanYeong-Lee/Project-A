using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ArrowSlot : UIBase
{
    [SerializeField] private Define.AttributeType attributeType;

    public void UpdateArrowSlot(int amount)
    {
        if (amount == 0)
        {
            images["ArrowImage"].color = ColorHelper.SetColorAlpha(images["ArrowImage"].color, 0.2f);
        }
        else
        {
            images["ArrowImage"].color = ColorHelper.SetColorAlpha(images["ArrowImage"].color, 1.0f);
        }
    }

    public void FocusSlot(bool focus)
    {
        if (focus)
        {
            images["Label"].color = ColorHelper.SetColorAlpha(images["Label"].color, 1.0f);
        }
        else
        {
            images["Label"].color = ColorHelper.SetColorAlpha(images["Label"].color, 0.2f);
        }
    }
}
