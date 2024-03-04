using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class AnimationHelper
{
    // 일정 속도로 화면 밖으로 내보내는 애니메이션
    public static IEnumerator Move(RectTransform rect, Define.Direction dir, float velocity)
    {
        Vector2 dirVec = Dir2Vec(dir);

        while (!IsOutScreen(rect))
        {
            rect.anchoredPosition += velocity * dirVec * Time.deltaTime;
            yield return null;
        }
    }

    // 시간 안에 비선형적으로 Target으로 이동시키는 애니메이션
    public static IEnumerator Move(RectTransform rect, Vector2 target, float velocity)
    {
        while (0.25f < Vector2.Distance(rect.position, target))
        {
            rect.position = Vector2.Lerp(rect.position, target, velocity * Time.deltaTime);
            yield return null;
        }

        rect.position = target;
    }

    public static IEnumerator Fade(MaskableGraphic graphic, float time, bool fadeIn)
    {
        Color color = graphic.material.color;
        float timeDelta = 0.0f;

        while (timeDelta < time)
        {
            timeDelta += Time.deltaTime;
            color.a += fadeIn ? Time.deltaTime / time : -Time.deltaTime / time;
            graphic.material.color = color;
            yield return null;
        }

        color.a = fadeIn ? 1.0f : 0.0f;
        graphic.material.color = color;
    }

    private static Vector2 Dir2Vec(Define.Direction dir)
    {
        switch (dir)
        {
            case Define.Direction.Up:
                return Vector2.up;

            case Define.Direction.Down:
                return Vector2.down;

            case Define.Direction.Left:
                return Vector2.left;

            case Define.Direction.Right:
                return Vector2.right;
        }

        return Vector2.zero;
    }

    public static bool IsOutScreen(RectTransform rect)
    {
        Vector2 screen = new Vector2(Screen.width, Screen.height);
        
        float up = rect.position.y + rect.sizeDelta.y * (1 - rect.pivot.y);
        float down = rect.position.y - rect.sizeDelta.y * rect.pivot.y;
        float left = rect.position.x - rect.sizeDelta.x * rect.pivot.x;
        float right = rect.position.x + rect.sizeDelta.x * (1 - rect.pivot.x);

        return right < 0 || screen.x < left || up < 0 || screen.y < down;
    }
}
