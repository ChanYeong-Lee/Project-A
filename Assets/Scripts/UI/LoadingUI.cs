using System;
using UnityEngine;

public class LoadingUI : UIBase
{
    public float loadingAmount;
    
    protected override void Awake()
    {
        base.Awake();

        images["FillImage"].fillAmount = 0;
    }

    private void Update()
    {
        images["FillImage"].fillAmount = loadingAmount;
    }
}