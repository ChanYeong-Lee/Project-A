using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AimUI : UIBase
{
    [SerializeField] private Color defaultColor;
    [SerializeField] private Color targetColor;

    private Transform target;
    private float chargedAmount = 0.0f;

    private void Update()
    {
        if (target != null)
        {
            images["Aim"].color = ColorHelper.SetColorAlpha(images["Aim"].color, 0.5f);

            images["AimIndicator"].transform.position = Camera.main.WorldToScreenPoint(target.position);
            images["AimIndicator"].color = targetColor;
        }
        else
        {
            images["Aim"].color = ColorHelper.SetColorAlpha(images["Aim"].color, 1.0f);

            images["AimIndicator"].rectTransform.anchoredPosition = Vector3.zero;
            images["AimIndicator"].color = defaultColor;
        }

        if (0.0f < chargedAmount)
        {
            images["AimIndicator"].gameObject.SetActive(true);
            images["AimIndicator"].rectTransform.localScale = Mathf.Lerp(1.0f, 0.25f, chargedAmount) * Vector3.one;
        }
        else
        {
            images["AimIndicator"].gameObject.SetActive(false);
        }
    }

    public void SetTarget(Transform target)
    {
        this.target = target;
    }

    public void SetChargedAmount(float chargedAmount)
    {
        this.chargedAmount = chargedAmount;
    }
}
