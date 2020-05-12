using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

public class TouchInputManager : MonoBehaviour
{
    public float lastBeginTime = 0;
    public float timeForTap = .75f;
    private int sceneANumber = 1;
    public TextMesh textMeshFriend;
    public TextMesh textMeshFriend2;

    public UnityEvent unityAction;
    public int text2Count = 0;

    // Start is called before the first frame update
    void Start()
    {
        DontDestroyOnLoad(this.gameObject);
        Tap();
    }
    public void Updatetext2()
    {
        text2Count++;
        textMeshFriend2.text = text2Count.ToString();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Tap();
        }
        textMeshFriend.text = Input.touchCount.ToString();
        foreach (Touch touch in Input.touches)
        {
            
            if (touch.fingerId == 0)
            {
                if (Input.GetTouch(0).phase == TouchPhase.Began)
                {
                    Debug.Log("First finger entered!");
                    lastBeginTime = Time.time;
                }
                if (Input.GetTouch(0).phase == TouchPhase.Ended)
                {
                    Debug.Log("First finger left.");
                    if (Time.time - timeForTap < lastBeginTime)
                    {
                        unityAction?.Invoke();
                    }
                }
            }

            if (touch.fingerId == 1)
            {
                if (Input.GetTouch(1).phase == TouchPhase.Began)
                {
                    Debug.Log("Second finger entered!");
                }
                if (Input.GetTouch(1).phase == TouchPhase.Ended)
                {
                    Debug.Log("Second finger left.");
                }
            }
        }
    }
    public void Tap()
    {

        SceneManager.LoadScene(sceneANumber);

        if (sceneANumber == 1)
        {
            sceneANumber = 2;
        }
        else
        {
            sceneANumber = 1;
        }
    }
}
