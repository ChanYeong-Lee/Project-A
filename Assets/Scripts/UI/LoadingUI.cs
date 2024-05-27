using System;
using UnityEngine;
using UnityEngine.Serialization;

public class LoadingUI : UIBase
{
    private float loadingAmount;
    public float LoadingAmount { get => loadingAmount; set => loadingAmount = value; }

    protected override void Awake()
    {
        base.Awake();

        images["FillImage"].fillAmount = 0;
        texts["LoadingText"].text = "0 / 100%";
    }

    private void Update()
    {
        images["FillImage"].fillAmount = loadingAmount;
        texts["LoadingText"].text = $"{(int)(loadingAmount * 100)} / 100%";
    }
}