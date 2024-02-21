using UnityEngine;
using UnityEngine.EventSystems;

namespace Michsky.UI.Heat
{
    [AddComponentMenu("Heat UI/Input/Input Navigation Limiter")]
    public class InputNavigationLimiter : MonoBehaviour
    {
        void Update()
        {
            if (ControllerManager.instance != null && EventSystem.current.currentSelectedGameObject.transform.parent != transform.parent)
            {
                ControllerManager.instance.SelectUIObject(transform.GetChild(0).gameObject);
            }
        }
    }
}